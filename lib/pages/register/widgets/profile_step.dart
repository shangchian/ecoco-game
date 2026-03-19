import 'dart:developer' as dev;
import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/pages/common/alerts/register_success_alert.dart';
import 'package:ecoco_app/pages/common/alerts/registration_session_expired_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '/models/country_model.dart';
import '/models/district_model.dart';
import '/models/verify_otp_response_model.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/auth_button.dart';
import '/providers/area_district_provider.dart';
import '/providers/members_service_provider.dart';
import '/router/app_router.dart';
import '/services/online/base_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth_provider.dart';
import '/providers/register/register_provider.dart';
import '/pages/common/form_fields/nickname_field.dart';
import '/pages/common/form_fields/email_field.dart';
import '/pages/common/form_fields/birthday_field.dart';
import '/pages/common/form_fields/gender_field.dart';
import '/pages/common/form_fields/location_field.dart';

import '/l10n/app_localizations.dart';
import '/utils/router_analytics_extension.dart';

class ProfileStep extends ConsumerStatefulWidget {
  final VerifyOtpResponse tempTokens;
  final Function(bool) onLoadingChanged;
  final String? initialPassword;

  const ProfileStep({
    super.key,
    required this.tempTokens,
    required this.onLoadingChanged,
    this.initialPassword,
  });

  @override
  ConsumerState<ProfileStep> createState() => _ProfileStepState();
}

class _ProfileStepState extends ConsumerState<ProfileStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;
  DateTime? _selectedDate;
  String? _selectedGender;
  CountryModel? _selectedCountry;
  DistrictModel? _selectedDistrict;
  // bool _subscribeNews = true;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onEmailFocusChange);
    // Initialize selection after first frame
    // Data is already preloaded in SplashPage
    _initializeSelection();
  }

  void _onEmailFocusChange() {
    setState(() {
      _isEmailFocused = _emailFocusNode.hasFocus;
    });

    if (_isEmailFocused) {
      // Small delay to allow keyboard to animate up
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        final context = _emailFieldKey.currentContext;
        if (context != null && context.mounted) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.2, // Position item near top of scrollable area
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _initializeSelection() {
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      final area = ref.read(areaDistrictProvider);
      if (area.countries.isNotEmpty && _selectedCountry == null) {
        setState(() {
          _selectedCountry = area.countries.first;
          _selectedDistrict = _selectedCountry?.districts.first;
        });
      }
    });*/
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onEmailFocusChange);
    _emailFocusNode.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _validateNickname(String value) {
    // Check length constraint: max 10
    if (value.length > 10) return false;
    if (value.isEmpty) return true;
    // Check format: Chinese, English, numbers, spaces only
    return RegExp(r'^[a-zA-Z0-9\u4e00-\u9fa5\s]+$').hasMatch(value);
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) return true;
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value);
  }

  Future<void> _handleSubmit() async {
    // Manual validation check since validators always return null
    if (!_validateNickname(_nicknameController.text)) {
      return;
    }

    // Check email is required when subscribing to newsletter
    // final registerState = ref.read(registerProvider);
    // if (_subscribeNews && registerState.email.isEmpty) {
    //   await _showEmailRequiredDialog();
    //   return;
    // }

    if (_formKey.currentState?.validate() ?? false) {
      widget.onLoadingChanged(true);

      final notifier = ref.read(registerProvider.notifier);
      notifier.updateLocation(_selectedDistrict);

      try {
        // Get the members service and register state
        final membersService = ref.read(membersServiceProvider);
        final registerState = ref.read(registerProvider);

        // Step 1: Check and refresh token if needed
        VerifyOtpResponse currentTokens = widget.tempTokens;

        if (currentTokens.needsRefresh) {
          // Check if refresh token is also expired
          if (currentTokens.isRefreshTokenExpired) {
            // Both tokens expired - need to restart registration
            if (mounted) {
              widget.onLoadingChanged(false);
              await _showSessionExpiredDialog();
            }
            return;
          }

          // Try to refresh the token
          try {
            dev.log('Access token needs refresh, attempting to refresh...', name: 'ProfileStep');
            final newAuthData = await membersService.refreshToken(
              currentTokens.refreshToken,
            );

            // Update currentTokens with refreshed values
            currentTokens = currentTokens.copyWith(
              accessToken: newAuthData.accessToken,
              refreshToken: newAuthData.refreshToken,
              accessTokenExpiresAt: newAuthData.accessTokenExpiresAt,
              refreshTokenExpiresAt: newAuthData.refreshTokenExpiresAt,
            );
            dev.log('Token refreshed successfully', name: 'ProfileStep');
          } catch (e) {
            // Refresh failed - treat as session expired
            dev.log('Token refresh failed: $e', name: 'ProfileStep');
            if (mounted) {
              widget.onLoadingChanged(false);
              await _showSessionExpiredDialog();
            }
            return;
          }
        }

        // Debug logging to verify password sources
        dev.log('Password sources - registerState: ${registerState.password.isNotEmpty ? "${registerState.password.length} chars" : "EMPTY"}, initialPassword: ${widget.initialPassword?.isNotEmpty == true ? "${widget.initialPassword!.length} chars" : "EMPTY"}',
                name: 'ProfileStep');

        // Call updateRegistrationProfile to complete registration
        // Prefer registerState.password (set by PasswordStep or RegisterPage.initState),
        // fallback to initialPassword for safety
        final password = registerState.password.isNotEmpty
            ? registerState.password
            : (widget.initialPassword ?? '');

        if (password.isEmpty) {
          throw Exception('Password is required');
        }

        // 註冊完成，不儲存 authData，讓使用者重新登入以確保完整的初始化流程
        await membersService.updateRegistrationProfile(
          accessToken: currentTokens.accessToken,
          password: password,
          email: registerState.email.isNotEmpty ? registerState.email : null,
          nickname: registerState.nickname.isNotEmpty ? registerState.nickname : "可可粉",
          gender: registerState.gender?.toUpperCase(),
          birthday: registerState.birthday?.toIso8601String().split("T")[0] ?? '0000-00-00',
          areaId: registerState.areaId,
          districtId: registerState.districtId,
        );

        // Show success dialog
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => RegisterSuccessAlert(
              onConfirm: () async {
                // 自動登入
                try {
                  final authNotifier = ref.read(authProvider.notifier);
                  await authNotifier.login(registerState.phone, password);
                  // 執行登入後初始化
                  await authNotifier.performPostAuthInitialization();
                  // 關閉 dialog 並導向首頁
                  if (mounted) {
                    Navigator.pop(context);
                    context.router.pushAndPopUntilWithTracking(
                      const MainRoute(),
                      predicate: (_) => false,
                    );
                  }
                } catch (e) {
                  // 登入失敗時，關閉 dialog 並 fallback 到登入頁面
                  dev.log('Auto login failed after registration: $e', name: 'ProfileStep');
                  if (mounted) {
                    Navigator.pop(context);
                    context.router.pushAndPopUntilWithTracking(
                      LoginRoute(),
                      predicate: (_) => false,
                    );
                  }
                }
              },
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          await _showErrorDialog(e);
        }
      } finally {
        if (mounted) {
          widget.onLoadingChanged(false);
        }
      }
    }
  }

  /// Show session expired dialog and navigate to registration step 1
  Future<void> _showSessionExpiredDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RegistrationSessionExpiredAlert(
        onRestart: () {
          // Navigate back to registration step 1
          context.router.pushAndPopUntilWithTracking(
            RegisterRoute(),
            predicate: (_) => false,
          );
        },
      ),
    );
  }

  /// Show error dialog with user-friendly message
  Future<void> _showErrorDialog(dynamic error) async {
    final appLocale = AppLocalizations.of(context);

    String errorMessage;
    if (error is ApiException) {
      // Use server error message if available
      errorMessage = error.message.isNotEmpty
          ? error.message
          : (appLocale?.registrationError ?? '註冊過程中發生錯誤，請稍後再試');
    } else if (error is Exception) {
      // Extract meaningful message, avoid showing "Exception: null"
      String msg = error.toString();
      if (msg.startsWith('Exception: ')) {
        msg = msg.substring(11);
      }
      // If message is empty, null, or looks technical, use generic message
      if (msg.isEmpty || msg == 'null' || msg.contains('Exception')) {
        errorMessage = appLocale?.registrationError ?? '註冊過程中發生錯誤，請稍後再試';
      } else {
        errorMessage = msg;
      }
    } else {
      errorMessage = appLocale?.registrationError ?? '註冊過程中發生錯誤，請稍後再試';
    }

    await showDialog(
      context: context,
      builder: (_) => SimpleErrorAlert(
        title: appLocale?.registrationFailed ?? '註冊失敗',
        message: errorMessage,
        buttonText: appLocale?.okay ?? '確定',
        onPressed: () {},
      ),
    );
  }

  /// Show email required dialog when subscribing to newsletter
  // Future<void> _showEmailRequiredDialog() async {
  //   final appLocale = AppLocalizations.of(context);
  //
  //   await showDialog(
  //     context: context,
  //     builder: (_) => SimpleErrorAlert(
  //       title: '就差一步囉!',
  //       message: '想收到ECOCO電子報\n請記得填寫Email哦',
  //       buttonText: appLocale?.okay ?? '確定',
  //       onPressed: () {},
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final register = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    final area = ref.watch(areaDistrictProvider);

    final appLocale = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          if (mounted) {
            final navigator = AutoRouter.of(context);
            Future.microtask(() {
              navigator.replace(LoginRoute());
            });
          }
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
            child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NicknameFormField(
                  controller: _nicknameController,
                  onChanged: (value) => notifier.updateNickname(value),
                ),
                const SizedBox(height: 16),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: appLocale?.email ?? "Email",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  key: _emailFieldKey,
                  child: EmailFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onChanged: (value) => notifier.updateEmail(value),
                  ),
                ),
                const SizedBox(height: 16),

                LocationFormField(
                  countries: area.countries,
                  selectedCountry: _selectedCountry,
                  selectedDistrict: _selectedDistrict,
                  onChanged: (district) {
                    setState(() {
                      _selectedDistrict = district;
                    });
                    notifier.updateLocation(district);
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: GenderFormField(
                        selectedGender: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                          notifier.updateGender(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BirthdayFormField(
                        selectedDate: _selectedDate,
                        onChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                          ref
                              .read(registerProvider.notifier)
                              .updateBirthday(date);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.secondaryValueColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "性別、生日可編輯一次，儲存後無法變更",
                        style: const TextStyle(
                          color: AppColors.secondaryValueColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 8),

                // SubscribeNewsField(
                //   value: _subscribeNews,
                //   onChanged: (value) {
                //     FocusScope.of(context).unfocus();
                //     setState(() {
                //       _subscribeNews = value ?? false;
                //     });
                //     notifier.updateSubscribeNews(value ?? false);
                //   },
                // ),

                const SizedBox(height: 8),

                // 完成註冊按鈕
                AuthButton(
                    onPressed: () async {
                      FirebaseAnalytics.instance.logEvent(name: 'sign_up_submit');
                      FocusScope.of(context).unfocus();
                      await _handleSubmit();
                    },
                    label: appLocale?.finishedRegister ?? '',
                    isEnabled: !register.isLoading &&
                        _validateNickname(register.nickname) &&
                        _validateEmail(register.email) &&
                        register.birthday != null),
                const SizedBox(height: 150),
                SizedBox(height: _isEmailFocused ? MediaQuery.of(context).size.height * 0.45 : 0),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
