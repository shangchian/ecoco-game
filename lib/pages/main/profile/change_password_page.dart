import 'package:auto_route/auto_route.dart';
//import '/providers/bio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/pages/common/form_fields/password_builder_field.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/auth_button.dart';
import '/providers/auth_provider.dart';
import '/pages/common/loading_overlay.dart';
import '/l10n/app_localizations.dart';
import '/constants/colors.dart';
import '/repositories/auth_repository.dart';
import '/router/app_router.dart';

@RoutePage()
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.secondaryHighlightColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 56,
            title: Text(
              appLocale?.passwordEdit ?? "",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.router.pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 16, 35, 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PasswordBuilderFormField(
                            controller: _currentPasswordController,
                            onChanged: (value) {
                              setState(() {
                                _currentPassword = value;
                              });
                            },
                            mode: PasswordFieldMode.simple,
                            hintText: appLocale?.passwordEditCurrentHint ?? "",
                            labelText:
                                appLocale?.passwordEditCurrentLabel ?? "",
                          ),
                          const SizedBox(height: 24),
                          PasswordBuilderFormField(
                            controller: _newPasswordController,
                            onChanged: (value) {
                              setState(() {
                                _newPassword = value;
                              });
                            },
                            mode: PasswordFieldMode.builder,
                            hintText: appLocale?.passwordEditNewHint,
                            labelText: appLocale?.passwordEditNewLabel,
                          ),
                          const SizedBox(height: 24),
                          PasswordBuilderFormField(
                            controller: _confirmPasswordController,
                            onChanged: (value) {
                              setState(() {
                                _confirmPassword = value;
                              });
                            },
                            mode: PasswordFieldMode.confirm,
                            confirmPassword: _newPassword,
                            hintText: appLocale?.passwordEditNewConfirmHint,
                            labelText: appLocale?.passwordEditNewConfirmLabel,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  appLocale?.passwordRequirement ?? "",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          AuthButton(
                            onPressed: _handleChangePassword,
                            label: appLocale?.next ?? "下一步",
                            isEnabled: _isFormValid(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }

  Future<void> _handleChangePassword() async {
    setState(() => _isLoading = true);
    final appLocale = AppLocalizations.of(context);
    try {
      if (_newPassword.isNotEmpty &&
          _confirmPassword.isNotEmpty &&
          _newPassword == _confirmPassword) {
        final authNotifier = ref.read(authProvider.notifier);
        final isSuccess = await authNotifier.changePassword(
          _currentPassword,
          _newPassword,
        );

        if (isSuccess && mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SimpleErrorAlert(
              title: "密碼已更新",
              message: "密碼變更成功，請重新登入",
              buttonText: "重新登入",
              onPressed: () {
                // Dialog 確認後才登出並導航到登入頁
                authNotifier.logout();
                context.router.replaceAll([LoginRoute(isLogout: true)]);
              },
            ),
          );
        }
      }
    } on AuthenticationException catch (e) {
      // Handle specific error for wrong password (code 10002)
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '密碼錯誤',
            message: e.message, // Will show "目前密碼不正確" for code 10002
            buttonText: '重新輸入',
            onPressed: () {},
          ),
        );
      }
    } catch (e) {
      // Handle other errors
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: e.toString(),
            buttonText: appLocale?.okay ?? "",
            onPressed: () {},
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[a-zA-Z]'))) return false;
    return true;
  }

  bool _isFormValid() {
    if (_isLoading) return false;
    if (_currentPassword.isEmpty) return false;
    if (!_isPasswordValid(_newPassword)) return false;
    if (_confirmPassword.isEmpty) return false;
    if (_newPassword != _confirmPassword) return false;
    return true;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
