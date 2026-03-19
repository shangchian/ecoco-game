import 'dart:async';

import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/pages/common/auth_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import '/l10n/app_localizations.dart';
import '/router/app_router.dart';
import '/models/verify_otp_response_model.dart';
import '/pages/common/form_fields/otp_field.dart';
import '/pages/common/form_fields/phone_field.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/alerts/simple_confirm_alert.dart';
import '/providers/auth_provider.dart';
import '/providers/register/register_provider.dart';
import '/providers/register/register_validator.dart';
import '/repositories/auth_repository.dart';
import '/services/online/base_service.dart';
import '/utils/router_analytics_extension.dart';

class AccountStep extends ConsumerStatefulWidget {
  final Function(VerifyOtpResponse) onNext;
  final Function(bool) onLoadingChanged;

  const AccountStep({
    super.key,
    required this.onNext,
    required this.onLoadingChanged,
  });

  @override
  ConsumerState<AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends ConsumerState<AccountStep>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _otpFieldKey = GlobalKey();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  String _currentPhone = '';
  String _verifyPhone = '';
  String _currentOTP = '';
  bool _canRequestOTP = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  DateTime? _otpExpiresAt;
  bool _isPhoneRegistered = false;
  bool _isOtpIncorrect = false;
  bool _isOtpFocused = false;
  bool _hasRequestedOTP = false;
  //bool _termsAgreed = false;
  //DateTime? _termsAgreedAt;
  int _otpRetryCount = 0;
  static const int _maxOtpRetries = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _otpFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isOtpFocused = _otpFocusNode.hasFocus;
    });

    if (_isOtpFocused) {
      // Small delay to allow keyboard to animate up
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        final context = _otpFieldKey.currentContext;
        if (context != null && context.mounted) {
          Scrollable.ensureVisible(
            context,
            alignment:
                0.2, // Position item near top of scrollable area (0.0 is top, 1.0 is bottom)
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _otpFocusNode.removeListener(_onFocusChange);
    _otpFocusNode.dispose();
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncTimerWithExpiration();
    }
  }

  /// 根據實際過期時間重新計算剩餘秒數
  void _syncTimerWithExpiration() {
    if (_otpExpiresAt == null) return;

    final now = DateTime.now();

    if (now.isAfter(_otpExpiresAt!)) {
      // OTP 已在背景時過期
      setState(() {
        _remainingSeconds = 0;
        _canRequestOTP = true;
      });
      _timer?.cancel();
    } else {
      // OTP 仍有效 - 重新計算剩餘秒數
      final newRemainingSeconds = _otpExpiresAt!.difference(now).inSeconds;
      if (newRemainingSeconds != _remainingSeconds) {
        setState(() {
          _remainingSeconds = newRemainingSeconds;
        });
      }
    }
  }

  String _getButtonText(AppLocalizations? appLocale) {
    if (_remainingSeconds > 0) {
      final minutes = (_remainingSeconds / 60).floor();
      final seconds = _remainingSeconds % 60;
      final time =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      return appLocale?.resendCode(time) ?? '';
    }
    return appLocale?.verifyPhone ?? '';
  }

  void _startTimer({DateTime? expiresAt}) {
    _timer?.cancel();

    if (expiresAt != null) {
      // Calculate remaining seconds from server timestamp
      final now = DateTime.now();
      _remainingSeconds = expiresAt.difference(now).inSeconds;
      if (_remainingSeconds < 0) _remainingSeconds = 0;
    } else {
      // Fallback to hardcoded 3 minutes
      _remainingSeconds = 180;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _canRequestOTP = true;
        }
      });
    });
  }

  bool get _isOtpValid {
    // Check if OTP has been requested (expiration time is set)
    if (_otpExpiresAt == null) return false;

    final trimmedOTP = _currentOTP.trim();

    // Check if OTP is filled (6 or more digits)
    if (trimmedOTP.length < 6) return false;

    // Check if OTP format is valid (digits only)
    if (!RegExp(r'^[0-9]{6,}$').hasMatch(trimmedOTP)) return false;

    return true;
  }

  Future<void> _requestOTP() async {
    final appLocale = AppLocalizations.of(context);
    widget.onLoadingChanged(true);
    try {
      final notifier = ref.read(authProvider.notifier);
      final response = await notifier.sendVerificationCode(_currentPhone);

      if (!mounted) return;

      setState(() {
        _otpExpiresAt = response.otpExpiresAt;
        _canRequestOTP = false;
        _hasRequestedOTP = true;
        _otpRetryCount = 0; // 重新發送後重置計數
      });

      // Start timer with server-provided expiration time
      _startTimer(expiresAt: response.otpExpiresAt);
    } catch (e) {
      if (mounted) {
        // 情境 4: 每日發送次數達上限
        if (e is OtpRateLimitException) {
          await showDialog(
            context: context,
            builder: (_) => SimpleErrorAlert(
              title: '已達次數上限',
              message: '您今日已發送${e.limit}次註冊驗證碼\n已達每日上限${e.limit}次，請明日再試',
              buttonText: appLocale?.okay ?? "確定",
              onPressed: () {},
            ),
          );
          // 對話框關閉後導航回 LoginPage
          if (mounted) {
            context.router.pushAndPopUntilWithTracking(
              LoginRoute(),
              predicate: (_) => false,
            );
          }
          return;
        }

        // 攔截門號已註冊錯誤 (code 10001)
        if (e is ApiException && e.code == ApiErrorCodes.phoneAlreadyRegistered) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SimpleConfirmAlert(
              title: '門號已註冊',
              message: '此號碼已經註冊過囉\n請重新輸入或前往登入',
              confirmText: '重新輸入',
              cancelText: '前往登入',
              highlightCancelButton: true,
              onConfirm: () {
                // 清空手機號碼輸入框
                _phoneController.clear();
                setState(() {
                  _currentPhone = '';
                  _canRequestOTP = false;
                  _isPhoneRegistered = false;
                });
              },
              onCancel: () {
                // 導航到登入頁面
                context.router.pushAndPopUntilWithTracking(
                  LoginRoute(),
                  predicate: (route) => false,
                );
              },
            ),
          );
          return;
        }

        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: e.toString(),
            buttonText: appLocale?.okay ?? "確定",
            onPressed: () {},
          ),
        );
      }
    } finally {
      if (mounted) {
        widget.onLoadingChanged(false);
        _verifyPhone = _currentPhone;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  appLocale?.setAccount ?? "設定帳號",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                PhoneFormField(
                  controller: _phoneController,
                  enabled: _otpExpiresAt == null,
                  onChanged: (value) {
                    _isPhoneRegistered = false;
                    setState(() {
                      _currentPhone = value;
                      _canRequestOTP =
                          RegisterValidator.validatePhone(value) == null;
                    });
                  },
                  isPhoneRegistered: _isPhoneRegistered,
                ),
                const SizedBox(height: 16),
                _remainingSeconds > 0
                    // 階段2：倒數中 - 顯示純文字
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _getButtonText(appLocale),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryValueColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : _hasRequestedOTP
                    // 階段3：倒數結束 - 帶底線的藍色文字連結
                    ? TextButton(
                        onPressed: _canRequestOTP && !_isPhoneRegistered
                            ? () async {
                                FocusScope.of(context).unfocus();
                                await _requestOTP();
                                if (mounted) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    FocusScope.of(context).unfocus();
                                  });
                                }
                              }
                            : null,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            appLocale?.verifyPhoneAgain ?? "重發驗證碼",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.loginTextbutton,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.loginTextbutton,
                            ),
                          ),
                        ),
                      )
                    // 階段1：初始 - 橘色按鈕
                    : AuthButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await _requestOTP();
                          if (mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              FocusScope.of(context).unfocus();
                            });
                          }
                        },
                        label: appLocale?.verifyPhone ?? '',
                        isEnabled: _canRequestOTP && !_isPhoneRegistered,
                      ),
                const Divider(
                  height: 28,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                Text(
                  appLocale?.otpTitle ?? "OTP簡訊驗證",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  key: _otpFieldKey,
                  child: OTPFormField(
                    controller: _otpController,
                    focusNode: _otpFocusNode,
                    useTextField: true,
                    isOtpIncorrect: _isOtpIncorrect,
                    onChanged: (value) {
                      setState(() {
                        _currentOTP = value;
                        _isOtpIncorrect = false; // Reset error when user types
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      //AutoRouter.of(context).pushWithTracking(const RegisterRoute());
                    },
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.loginTextbutton,
                        ),
                        children: [
                          const TextSpan(text: '無法收到簡訊驗證碼嗎？'),
                          TextSpan(
                            text: '聯繫客服協助',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.loginTextbutton,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.loginTextbutton,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final uri = Uri.parse(
                                  'https://ecocogroup.zendesk.com/hc/zh-tw/requests/new',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AuthButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await _handleNext();
                  },
                  label: appLocale?.next ?? "下一步",
                  isEnabled: _isOtpValid,
                ),
                SizedBox(
                  height: _isOtpFocused
                      ? MediaQuery.of(context).size.height * 0.65
                      : 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleNext() async {
    final appLocale = AppLocalizations.of(context);

    // 情境 1: 前端攔截 - 已達最大嘗試次數 (第四次嘗試)
    if (_otpRetryCount >= _maxOtpRetries) {
      await showDialog(
        context: context,
        builder: (_) => SimpleErrorAlert(
          title: '驗證碼錯誤',
          message: '驗證碼輸入錯誤次數過多\n請重新發送驗證',
          buttonText: appLocale?.okay ?? "確定",
          onPressed: () {},
        ),
      );
      // 按下確定後清空
      setState(() {
        _otpExpiresAt = null;
        _currentOTP = '';
        _otpController.clear();
        _otpRetryCount = 0;
      });
      return;
    }

    // Verify phone number matches the one that received OTP
    if (_verifyPhone != _currentPhone) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: appLocale?.otpErrorInput2 ?? "請使用收到驗證碼的手機號碼",
            buttonText: appLocale?.okay ?? "確定",
            onPressed: () {},
          ),
        );
      }
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Call server to verify OTP
    widget.onLoadingChanged(true);
    try {
      final authNotifier = ref.read(authProvider.notifier);

      final response = await authNotifier.verifyRegistrationOtp(
        phone: _currentPhone,
        otpCode: _currentOTP,
        termsAgreedAt: DateTime.now().toIso8601String(),
      );

      if (!mounted) return;

      // Success - reset retry count and proceed to next step
      setState(() {
        _otpRetryCount = 0;
        _isOtpIncorrect = false;
      });

      // Update register provider with phone and OTP
      final registerNotifier = ref.read(registerProvider.notifier);
      registerNotifier.updatePhone(_currentPhone);
      registerNotifier.updateOTP(_currentOTP);

      // Pass temporary tokens to next step
      widget.onNext(response);
    } catch (e) {
      if (!mounted) return;

      // Use type-safe error code checking instead of string matching
      if (e is ApiException) {
        switch (e.code) {
          case ApiErrorCodes.otpExpired:
            // Code 10005: OTP 已過期 - 重置 UI 和計數
            setState(() {
              _otpExpiresAt = null;
              _currentOTP = '';
              _otpController.clear();
              _isOtpIncorrect = false;
              _otpRetryCount = 0; // 過期需重新發送，重置計數
            });

            await showDialog(
              context: context,
              builder: (_) => SimpleErrorAlert(
                title: '驗證碼已失效',
                message: '本次操作時效已過\n請重新取得驗證',
                buttonText: appLocale?.okay ?? "確定",
                onPressed: () {},
              ),
            );

          case ApiErrorCodes.otpIncorrect:
            // Code 10006: OTP 輸入錯誤 - 增加重試計數
            setState(() {
              _otpRetryCount++;
              _isOtpIncorrect = true;
            });

            if (_otpRetryCount >= _maxOtpRetries) {
              // 第 3 次錯誤：顯示錯誤次數過多，但不重置計數
              await showDialog(
                context: context,
                builder: (_) => SimpleErrorAlert(
                  title: '驗證碼錯誤',
                  message: '驗證碼輸入錯誤次數過多\n請重新發送驗證',
                  buttonText: appLocale?.okay ?? "確定",
                  onPressed: () {},
                ),
              );
              // 清空輸入但不重置計數，讓第四次被前端攔截
              setState(() {
                _otpExpiresAt = null;
                _currentOTP = '';
                _otpController.clear();
              });
            } else {
              // 第 1、2 次錯誤：顯示剩餘機會
              final remainingAttempts = _maxOtpRetries - _otpRetryCount;
              await showDialog(
                context: context,
                builder: (_) => SimpleErrorAlert(
                  title: '驗證碼錯誤',
                  message: '驗證碼不正確，請重新輸入\n您還有 $remainingAttempts 次輸入機會',
                  buttonText: appLocale?.okay ?? "確定",
                  onPressed: () {},
                ),
              );
              // 清空驗證碼輸入
              setState(() {
                _currentOTP = '';
                _otpController.clear();
              });
            }

          case ApiErrorCodes.phoneAlreadyRegistered:
            // Code 10001: Phone already registered
            await showDialog(
              context: context,
              builder: (_) => SimpleErrorAlert(
                message: e.message, // Use server message
                buttonText: appLocale?.okay ?? "確定",
                onPressed: () {},
              ),
            );

          default:
            // Other API errors - use server message
            await showDialog(
              context: context,
              builder: (_) => SimpleErrorAlert(
                message: e.message,
                buttonText: appLocale?.okay ?? "確定",
                onPressed: () {},
              ),
            );
        }
      } else {
        // Handle non-API exceptions (network errors, etc.)
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: e.toString(),
            buttonText: appLocale?.okay ?? "確定",
            onPressed: () {},
          ),
        );
      }
    } finally {
      if (mounted) {
        widget.onLoadingChanged(false);
      }
    }
  }
}
