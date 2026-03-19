import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/services/online/base_service.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '/l10n/app_localizations.dart';
import '/constants/colors.dart';
import '/models/verify_otp_response_model.dart';
import '/utils/system_ui_style_helper.dart';

import '/pages/common/alerts/simple_confirm_alert.dart';
import '/pages/common/alerts/password_error_alert.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/auth_page_layout.dart';
import '/pages/common/form_fields/password_builder_field.dart';
import '/pages/common/form_fields/phone_field.dart';
import '/pages/common/loading_overlay.dart';
import '/widgets/terms_and_privacy_dialog.dart';

import '/providers/auth_provider.dart';
import '/providers/bio_provider.dart';
import '/providers/login_provider.dart';

import '/repositories/auth_repository.dart';

import '/providers/app_mode_provider.dart';
import '/router/app_router.dart';
import '/services/storage_service.dart';
import '/utils/router_analytics_extension.dart';
//import '/services/members_service.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
    this.onLoginSuccess,
    this.relogin = false,
    this.forceBiometric = false,
    this.phoneNumber,
    this.isLogout = false,
  });

  final Future<void> Function(String username, String password)? onLoginSuccess;
  final bool relogin; // 是否為重新登入, 重新登入時：不顯示忘記密碼, 不顯示註冊, 登入完成後使用maybePop離開
  final bool forceBiometric; // 是否強制使用生物辨識, 強制使用時直接寫入生物辨識資料
  final String? phoneNumber; // 預填手機號碼，給重新登入使用，使用預填時不讓使用者修改手機號碼
  final bool isLogout; // 是否為登出後跳轉過來，若是則延遲生物辨識彈窗避免閃現

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String _currentPhone = '';
  String _currentPassword = '';
  final _passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _initializePhone();
    _loadRememberedPhone();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeBiometricLogin();
      }
    });
    _checkLogoutMessage();
  }

  void _checkLogoutMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final logoutReason = ref.read(logoutReasonProvider);
      if (logoutReason != null) {
        // 如果是登出跳轉，延遲顯示訊息避免與轉場衝突
        if (widget.isLogout) {
          await Future.delayed(const Duration(milliseconds: 1510));
        }

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => SimpleErrorAlert(
              title: '登入提示',
              message: logoutReason,
              buttonText: '確定',
              onPressed: () {
                // Just close the dialog
              },
            ),
          );
          // 顯示後立即清除，避免重複顯示或影響下次正常登出
          ref.read(logoutReasonProvider.notifier).state = null;
        }
      }
    });
  }

  void _initializePhone() {
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber!;
      _currentPhone = widget.phoneNumber!;
    }
  }

  Future<void> _loadRememberedPhone() async {
    // 如果已經有預填的手機號碼（重新登入場景），不覆蓋
    if (widget.phoneNumber != null) return;

    try {
      final rememberedPhone = await _storageService.getRememberedPhone();
      if (rememberedPhone != null && rememberedPhone.isNotEmpty && mounted) {
        setState(() {
          phoneController.text = rememberedPhone;
          _currentPhone = rememberedPhone;
          _rememberMe = true;
        });
      }
    } catch (e) {
      log('Failed to load remembered phone: $e');
    }
  }

  Future<void> _initializeBiometricLogin() async {
    final now = DateTime.now();
    log('BIO: _initializeBiometricLogin at ${now.toIso8601String()}, isLogout=${widget.isLogout}');
    // 如果是登出跳轉過來的，延遲一下再啟動生物辨識，避免使用者還沒看到登入頁就被彈窗擋住
    if (widget.isLogout) {
      log('BIO: Logout detected, delaying for 800ms...');
      await Future.delayed(const Duration(milliseconds: 800));
      log('BIO: Delay finished at ${DateTime.now().toIso8601String()}');
    }

    try {
      log('BIO: Starting loginUsingBiometric at ${DateTime.now().toIso8601String()}');
      final result = await ref.read(authProvider.notifier).loginUsingBiometric(
            onAuthenticated: () {
              log('BIO: onAuthenticated triggered at ${DateTime.now().toIso8601String()}');
              if (mounted) setState(() => _isLoading = true);
            },
          );
      if (result != null && mounted) {
        log('BIO: Result not null, navigating...');
        _navigateAfterLogin();
      }
    } on AuthException {
      log('BIO: AuthException (HasBiometric=true)');
      ref.read(loginProvider.notifier).updateHasBiometric(true);
    } on AuthenticationException catch (e) {
      log('BIO: AuthenticationException, code=${e.code} at ${DateTime.now().toIso8601String()}');
      if (e.code == AuthErrorCode.noData ||
          e.code == AuthErrorCode.unSupported) {
        ref.read(loginProvider.notifier).updateHasBiometric(false);
      }
    } catch (e) {
      log('BIO: Unexpected error: $e');
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      log('BIO: _initializeBiometricLogin finished at ${DateTime.now().toIso8601String()}');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final loginState = ref.watch(loginProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiStyleHelper.defaultStyle,
      child: Stack(
        children: [
        // Full screen yellow background (static)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/yellow_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Changed to transparent
          appBar: widget.relogin
              ? AppBar(
                  title: Text(
                    widget.relogin
                        ? (appLocale?.reverify ?? "")
                        : (appLocale?.login ?? ""),
                  ),
                )
              : null,
          resizeToAvoidBottomInset: true, // Allow resizing to avoid keyboard obscuring input fields
          body: SafeArea(
            top: false,
            bottom: false,
            child: AuthPageLayout(
              showYellowBackground: !widget.relogin,
              topPadding: widget.relogin ? 0 : 160,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    // Removed dynamic padding
                    left: 35.0,
                    right: 35.0,
                    top: 32.0,
                    bottom: 16.0, // Removed dynamic padding
                  ),
                  child: AutofillGroup(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Branding section
                        if (!widget.relogin) ...[
                          const Text(
                            'OUR GAME FOR HOME EARTH',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.loginGray,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '準備好一起來玩了嗎？',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryHighlightColor,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                        // Account number label and field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                '帳號',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              PhoneFormField(
                                controller: phoneController,
                                onChanged: (value) {
                                  setState(() {
                                    _currentPhone = value;
                                  });
                                },
                                enabled: widget.phoneNumber == null,
                              ),
                              const SizedBox(height: 24),
                              // Password label and field
                              PasswordBuilderFormField(
                                controller: _passwordController,
                                onChanged: (value) {
                                  setState(() {
                                    _currentPassword = value;
                                  });
                                },
                                mode: PasswordFieldMode.simple,
                                labelText: '密碼',
                                hintText: appLocale?.passwordHint ?? '輸入密碼',
                              ),
                              const SizedBox(height: 16),
                              // Remember me and forgot password
                              if (!widget.relogin) ...[
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            fillColor:
                                                WidgetStateProperty.resolveWith(
                                                  (states) {
                                                    if (states.contains(
                                                      WidgetState.selected,
                                                    )) {
                                                      return AppColors
                                                          .orangeBackground;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                            onChanged: (value) async {
                                              FocusScope.of(context).unfocus();

                                              final newValue = value ?? false;

                                              // 如果取消勾選，立即清除已保存的帳號
                                              if (!newValue) {
                                                try {
                                                  await _storageService
                                                      .clearRememberedPhone();
                                                } catch (e) {
                                                  log(
                                                    'Failed to clear remembered phone: $e',
                                                  );
                                                }
                                              }

                                              setState(() {
                                                _rememberMe = newValue;
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          appLocale?.rememberMe ?? '記住我',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        AutoRouter.of(
                                          context,
                                        ).pushThrottledWithTracking(const ForgetPasswordRoute());
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        appLocale?.forgotPassword ?? '忘記密碼',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.loginTextbutton,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColors.loginTextbutton,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 32),
                              // Login button
                              _buildLoginButtons(
                                appLocale,
                                loginState.hasBiometric,
                              ),
                              const SizedBox(height: 24),
                              // Register link
                              if (!widget.relogin) ...[
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      FirebaseAnalytics.instance.logEvent(
                                        name: 'sign_up_start',
                                      );
                                      AutoRouter.of(
                                        context,
                                      ).pushThrottledWithTracking(RegisterRoute());
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.loginTextbutton,
                                        ),
                                        children: [
                                          const TextSpan(text: '還沒有帳號？'),
                                          TextSpan(
                                            text: '點這裡註冊',
                                            style: const TextStyle(
                                              color: AppColors.loginTextbutton,
                                              fontWeight: FontWeight.w900,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColors.loginTextbutton,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                // Terms and Privacy Policy
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: '登入即代表您同意ECOCO的\n',
                                        ),
                                        TextSpan(
                                          text: '服務條款及隱私權政策',
                                          style: const TextStyle(
                                            color: AppColors.loginTextbutton,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppColors.loginTextbutton,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              TermsAndPrivacyDialog.show(
                                                context,
                                                requireScrollToBottom: false,
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
      ),
    );
  }

  Widget _buildLoginButtons(AppLocalizations? appLocale, bool hasBiometric) {
    final bool isFormValid =
        _currentPhone.isNotEmpty && _currentPassword.isNotEmpty;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: isFormValid
                ? () => _handleLogin(
                    context,
                    ref,
                    _currentPhone,
                    _currentPassword,
                  )
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFormValid
                  ? AppColors.loginButtonOrange
                  : AppColors.loginButtonGray,
              disabledBackgroundColor: AppColors.loginButtonGray,
              padding: const EdgeInsets.symmetric(vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              widget.relogin
                  ? (appLocale?.reverify ?? "")
                  : (appLocale?.login ?? "登入"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (hasBiometric) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () => _handleBiometricLogin(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.loginButtonGray,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showError(dynamic error) {
    if (!mounted) return;

    // Check if error is AuthenticationException to determine alert type
    if (error is AuthenticationException) {
      switch (error.code) {
        case AuthErrorCode.invalidCredentials:
          // Show password error alert with retry and forgot password options
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => PasswordErrorAlert(
              onRetry: () {
                if (mounted) {
                  setState(() {
                    _passwordController.clear();
                    _currentPassword = '';
                  });
                }
              },
              onForgotPassword: () {
                if (mounted) {
                  context.router.pushThrottledWithTracking(const ForgetPasswordRoute());
                }
              },
            ),
          );
          break;

        case AuthErrorCode.unauthorized:
        case AuthErrorCode.serverError:
        case AuthErrorCode.networkError:
        case AuthErrorCode.unknown:
        default:
          // Show simple error alert for other error types
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => SimpleErrorAlert(
              message: error.message,
              buttonText: '確定',
              onPressed: () {
                // Just close the dialog
              },
            ),
          );
          break;
      }
    } else {
      // For non-AuthenticationException errors, show simple error alert
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => SimpleErrorAlert(
          message: error.toString(),
          buttonText: '確定',
          onPressed: () {
            // Just close the dialog
          },
        ),
      );
    }
  }

  void _navigateAfterLogin() {
    log('LOGIN: _navigateAfterLogin called, mounted=$mounted, relogin=${widget.relogin}');
    if (!mounted) return;
    if (!widget.relogin) {
      final mode = ref.read(appModeStateProvider);
      log('LOGIN: Navigating to home, mode=$mode');
      if (mode == AppMode.game) {
        context.router.pushAndPopUntilWithTracking(
          const GameHomeRoute(),
          predicate: (_) => false,
        );
      } else {
        context.router.pushAndPopUntilWithTracking(
          const MainRoute(),
          predicate: (_) => false,
        );
      }
    } else {
      log('LOGIN: Relogin detected, popping');
      context.router.maybePop();
    }
  }

  Future<void> _handleBiometricAuth(String username, String password) async {
    if (widget.forceBiometric) {
      await _handleForcedBiometric(username, password);
    } else {
      await _showBiometricPrompt(username, password);
    }
  }

  Future<void> _handleLogin(
    BuildContext context,
    WidgetRef ref,
    String username,
    String password,
  ) async {
    FirebaseAnalytics.instance.logEvent(name: 'login_attempt');
    setState(() => _isLoading = true);
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.login(
          username,
          password,
          bypassStateIfErr: widget.relogin,
        );

        // 處理「記住我」功能
        try {
          if (_rememberMe) {
            await _storageService.saveRememberedPhone(username);
          } else {
            await _storageService.clearRememberedPhone();
          }
        } catch (e) {
          log('Failed to handle remember me: $e');
        }

        if (widget.onLoginSuccess != null) {
          await widget.onLoginSuccess!(username, password);
        }

        // Show initialization overlay
        /*if (context.mounted) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const InitializationOverlay(),
          );
        }*/

        FirebaseAnalytics.instance.logEvent(name: 'login');

        // Post-auth initialization is now handled internally by authNotifier.login()
        // so we don't need to call it manually here anymore.

        if (context.mounted) {
          setState(() => _isLoading = false);
        }

        if (context.mounted) {
          FocusScope.of(context).unfocus(); // Prevent keyboard flickering
          _handleBiometricAuth(username, password);
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        _showError(e);
      }
    } on IncompleteRegistrationException catch (e) {
      // User has verified phone but not completed registration
      // Navigate to registration page at password step with their tokens
      if (mounted) {
        setState(() => _isLoading = false);

        // Convert AuthData to VerifyOtpResponse format
        final tempTokens = VerifyOtpResponse(
          accessToken: e.authData.accessToken,
          refreshToken: e.authData.refreshToken,
          tokenType: e.authData.tokenType,
          accessTokenExpiresAt: e.authData.accessTokenExpiresAt,
          refreshTokenExpiresAt: e.authData.refreshTokenExpiresAt,
          memberId: e.authData.memberId.toString(),
          memberStatus: e.authData.memberStatus,
        );

        // Navigate to registration page, starting at profile step (step 2)
        // Pass the password from login form so it's available for registration
        if (context.mounted) {
          context.router.pushThrottledWithTracking(
            RegisterRoute(
              initialTokens: tempTokens,
              initialStep: 2,
              initialPassword: password,
              initialPhone: username,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showError(e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleBiometricLogin(
      BuildContext context, WidgetRef ref) async {
    setState(() => _isLoading = true);
    try {
      final authNotifier = ref.read(authProvider.notifier);
      final result = await authNotifier.loginUsingBiometric();
      if (result != null && mounted) {
        _navigateAfterLogin();
      }
    } on AuthenticationException catch (e) {
      if (e.code == AuthErrorCode.noData) {
        ref.read(loginProvider.notifier).updateHasBiometric(false);
      }
      log('Biometric login failed: ${e.message}');
    } catch (e) {
      log('Biometric login error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /*Future<void> _handleNotification(BuildContext context, WidgetRef ref) async {
    try {
      final notificationRepo = ref.read(notificationRepositoryProvider);
      final authData = ref.read(authProvider);
      if (authData != null) {
        //await notificationRepo.synchronizeNotificationToken(authData);
      }
    } catch (e) {
      if (mounted) {
        log(e.toString());
      }
    }
  }*/

  Future<void> _handleForcedBiometric(String username, String password) async {
    final bioNotifier = ref.read(bioProvider.notifier);
    await bioNotifier.saveBiometricData(username, password);
    if (mounted) {
      _navigateAfterLogin();
    }
  }

  Future<void> _showBiometricPrompt(String username, String password) async {
    if (!mounted) return;
    final bioNotifier = ref.read(bioProvider.notifier);
    final isSaved = await bioNotifier.isSaveBiometricData();

    if (isSaved) {
      _navigateAfterLogin();
      return;
    }

    if (mounted) {
      final appLocale = AppLocalizations.of(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SimpleConfirmAlert(
          title: appLocale?.bioActivate ?? "啟動生物辨識",
          message: appLocale?.bioActivateMsg ?? "您想要啟動生物辨識登入嗎？",
          onConfirm: () async {
            log('LOGIN: Biometric enrollment confirmed');
            // Save data and then navigate immediately for better UX
            // (Avoiding another biometric scan right after password login)
            await bioNotifier.saveBiometricData(username, password);
            log('LOGIN: Biometric enrollment data saved');
            if (mounted) {
              _navigateAfterLogin();
            }
          },
          onCancel: () {
            if (mounted) {
              _navigateAfterLogin();
            }
          },
        ),
      );
    }
  }
}
