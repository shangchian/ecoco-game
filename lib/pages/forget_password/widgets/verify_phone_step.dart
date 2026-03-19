import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/pages/common/auth_button.dart';
import 'package:flutter/foundation.dart';

import '/models/send_otp_response_model.dart';
import '/router/app_router.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/alerts/verification_error_alert.dart';
import '/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/providers/forget_password_provider.dart';
import '/pages/common/form_fields/otp_field.dart';
import '/repositories/auth_repository.dart';
import '/services/online/base_service.dart';
import '/utils/snackbar_helper.dart';
import '/utils/router_analytics_extension.dart';

class VerifyPhoneStep extends ConsumerStatefulWidget {
  const VerifyPhoneStep({
    super.key,
    required this.onNext,
    required this.onLoadingChanged,
  });

  final void Function() onNext;
  final Function(bool) onLoadingChanged;

  @override
  ConsumerState<VerifyPhoneStep> createState() => _VerifyPhoneStepState();
}

class _VerifyPhoneStepState extends ConsumerState<VerifyPhoneStep> {
  Timer? _timer;
  int _remainingSeconds = 180; // 3分鐘 = 180秒
  bool _canResend = false;
  late final TextEditingController _otpController;
  final FocusNode _otpFocusNode = FocusNode();

  // OTP retry tracking
  int _otpRetryCount = 0;
  final int _maxOtpRetries = 3;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _otpController = TextEditingController(
      text: ref.read(forgetPasswordControllerProvider).verificationCode,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _startTimer({DateTime? otpExpiresAt}) {
    _timer?.cancel();

    // Calculate remaining seconds from server timestamp if available
    if (otpExpiresAt != null) {
      final now = DateTime.now();
      _remainingSeconds = otpExpiresAt.difference(now).inSeconds;
      if (_remainingSeconds < 0) _remainingSeconds = 0;
    } else {
      // Fallback: check if we have timing info in state
      final state = ref.read(forgetPasswordControllerProvider);
      if (state.otpExpiresAt != null) {
        final now = DateTime.now();
        final diff = state.otpExpiresAt!.difference(now).inSeconds;

        // Use calculated diff if valid (between 1-300 seconds), otherwise fallback
        if (diff >= 1 && diff <= 300) {
          _remainingSeconds = diff;
        } else {
          // If diff is 0, negative, or too large, use fallback
          _remainingSeconds = 180;
        }
      } else {
        // Final fallback to hardcoded 3 minutes
        _remainingSeconds = 180;
      }
    }

    setState(() {
      _canResend = false; // Always start disabled, timer will enable it when countdown reaches 0
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String _formatTime() {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _resendVerificationCode() async {
    final state = ref.read(forgetPasswordControllerProvider);

    widget.onLoadingChanged(true);
    try {
      final authNotifier = ref.read(authProvider.notifier);
      final response = await authNotifier.sendForgetPasswordVerificationCode(
        state.phoneNumber,
      );

      if (!mounted) return;

      // Update timing info in state
      ref
          .read(forgetPasswordControllerProvider.notifier)
          .updateOtpResponse(response);

      // Restart timer with new timing
      _startTimer(otpExpiresAt: response.otpExpiresAt);

      // Show message in debug mode
      if (kDebugMode && mounted) {
        final message = response.action == SendOtpAction.sent
            ? "驗證碼已重新發送"
            : "已有有效的驗證碼";
        SnackBarHelper.show(context, message);
      }
    } catch (e) {
      if (!mounted) return;
      final appLocale = AppLocalizations.of(context);

      // 檢查客戶端每日發送限制 - 按確定後回到 LoginPage
      if (e is OtpRateLimitException) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '已達次數上限',
            message: '您今日已發送${e.limit}次密碼重設驗證碼\n已達每日上限${e.limit}次，請明日再試',
            buttonText: appLocale?.okay ?? "確認",
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

      // 檢查 API 異常
      if (e is ApiException) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: e.message,
            buttonText: appLocale?.okay ?? "確認",
            onPressed: () {},
          ),
        );
        return;
      }

      // 其他錯誤（網路等）
      await showDialog(
        context: context,
        builder: (_) => SimpleErrorAlert(
          message: e.toString(),
          buttonText: appLocale?.okay ?? "確認",
          onPressed: () {},
        ),
      );
    } finally {
      if (mounted) {
        widget.onLoadingChanged(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final state = ref.watch(forgetPasswordControllerProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          left: 35,
          right: 35
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                    Center(child: Text(appLocale?.verifyPhoneSentTo ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryValueColor,
                        ))),
                    Center(
                      child: Text(
                        ref
                            .read(forgetPasswordControllerProvider.notifier)
                            .parserPhoneNumber(state.phoneNumber),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryValueColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    OTPFormField(
                      onChanged: (value) {
                        ref
                            .read(forgetPasswordControllerProvider.notifier)
                            .updateVerificationCode(value);
                      },
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      autofocus: true,
                      useTextField: true,
                    ),
                    const SizedBox(height: 20),
                    _canResend
                        ? TextButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              await _resendVerificationCode();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              appLocale?.resendCodeBtn ?? "重發驗證碼",
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.indicatorColor,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.indicatorColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              appLocale?.resendCode(_formatTime()) ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.secondaryValueColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    AuthButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        final isOtpValid =
                            state.verificationCode.trim().length == 6 &&
                            RegExp(
                              r'^[0-9]{6}$',
                            ).hasMatch(state.verificationCode.trim());

                        if (!isOtpValid) {
                          if (context.mounted) {
                            await showDialog(
                              context: context,
                              builder: (_) => VerificationErrorAlert(
                                canResend: _canResend,
                                resendCountdownText: _canResend
                                    ? null
                                    : appLocale?.resendCode(_formatTime()),
                                onRetry: () {
                                  _otpController.clear();
                                  _otpFocusNode.requestFocus();
                                },
                                onResend: () async {
                                  await _resendVerificationCode();
                                  _otpController.clear();
                                  _otpFocusNode.requestFocus();
                                },
                              ),
                            );
                          }
                          return;
                        }

                        // OTP format is valid, now verify with server
                        widget.onLoadingChanged(true);
                        try {
                          final authNotifier = ref.read(authProvider.notifier);
                          final response = await authNotifier
                              .verifyOtpForPasswordReset(
                                phone: state.phoneNumber,
                                otpCode: state.verificationCode,
                              );

                          if (!mounted) return;

                          // Store resetToken, memberId and expiration in state
                          ref
                              .read(forgetPasswordControllerProvider.notifier)
                              .updateResetToken(
                                response.resetToken,
                                DateTime.parse(response.expiresAt),
                                response.memberId,
                              );

                          // Proceed to next step
                          widget.onNext();
                        } catch (e) {
                          if (!mounted) return;

                          // Use type-safe error code checking instead of string matching
                          if (e is ApiException) {
                            switch (e.code) {
                              case ApiErrorCodes.otpExpired:
                                // Code 10005: OTP expired - reset UI state
                                _otpController.clear();
                                _otpFocusNode.requestFocus();
                                setState(() {
                                  _otpRetryCount = 0;
                                });

                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (_) =>
                                        SimpleErrorAlert(
                                          title: '驗證碼已失效',
                                          message: e.message,
                                          // Use server message
                                          buttonText: '確認',
                                          onPressed: () {},
                                        ),
                                  );
                                }

                              case ApiErrorCodes.otpIncorrect:
                                // Code 10006: Wrong OTP - increment retry counter
                                setState(() {
                                  _otpRetryCount++;
                                });

                                if (_otpRetryCount >= _maxOtpRetries) {
                                  // Force user to resend OTP after max retries
                                  _otpController.clear();
                                  _otpFocusNode.requestFocus();
                                  setState(() {
                                    _otpRetryCount = 0;
                                  });

                                  if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (_) => SimpleErrorAlert(
                                      title: '驗證碼錯誤',
                                      message: '驗證碼輸入錯誤次數過多\n請重新發送驗證碼',
                                      buttonText: '確認',
                                      onPressed: () {},
                                    ),
                                  );
                                  }
                                } else {
                                  // Show remaining attempts
                                  _otpController.clear();
                                  _otpFocusNode.requestFocus();

                                  if (context.mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (_) =>
                                          SimpleErrorAlert(
                                            title: '驗證碼錯誤',
                                            message:
                                            '${e
                                                .message}\n您還有 ${_maxOtpRetries -
                                                _otpRetryCount} 次輸入機會',
                                            buttonText: '確認',
                                            onPressed: () {},
                                          ),
                                    );
                                  }
                                }

                              case ApiErrorCodes.accountNotRegistered:
                                // Code 10003: Account not registered
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (_) =>
                                        SimpleErrorAlert(
                                          title: '門號尚未註冊',
                                          message: e.message,
                                          // Use server message
                                          buttonText: '確認',
                                          onPressed: () {
                                            _otpController.clear();
                                            _otpFocusNode.requestFocus();
                                          },
                                        ),
                                  );
                                }

                              default:
                                // Other API errors - use server message
                                await showDialog(
                                  context: context,
                                  builder: (_) => SimpleErrorAlert(
                                    message: e.message,
                                    buttonText: '確認',
                                    onPressed: () {
                                      _otpController.clear();
                                      _otpFocusNode.requestFocus();
                                    },
                                  ),
                                );
                            }
                          } else {
                            // Handle non-API exceptions (network errors, etc.)
                            if (context.mounted) {
                              await showDialog(
                                context: context,
                                builder: (_) =>
                                    SimpleErrorAlert(
                                      message: e.toString(),
                                      buttonText: '確認',
                                      onPressed: () {
                                        _otpController.clear();
                                        _otpFocusNode.requestFocus();
                                      },
                                    ),
                              );
                            }
                          }
                        } finally {
                          if (mounted) {
                            widget.onLoadingChanged(false);
                          }
                        }
                      },
                      label: appLocale?.next ?? "下一步",
                      isEnabled: state.verificationCode.trim().length == 6 &&
                          RegExp(r'^[0-9]{6}$')
                              .hasMatch(state.verificationCode.trim()),
                    ),
          ],
        ),
      ),
    );
  }
}
