import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/pages/common/auth_button.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/alerts/reset_password_success_alert.dart';
import '/providers/auth_provider.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/providers/forget_password_provider.dart';
import '/pages/common/form_fields/password_builder_field.dart';
import '/utils/router_analytics_extension.dart';

class ResetPasswordStep extends ConsumerStatefulWidget {
  final Function(bool) onLoadingChanged;
  const ResetPasswordStep({
    super.key,
    required this.onLoadingChanged,
  });

  @override
  ConsumerState<ResetPasswordStep> createState() => _ResetPasswordStepState();
}

class _ResetPasswordStepState extends ConsumerState<ResetPasswordStep> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 8 || password.length > 20) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[a-zA-Z]'))) return false;
    return true;
  }

  Future<void> _handleNext(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    final state = ref.watch(forgetPasswordControllerProvider);
    widget.onLoadingChanged(true);

    try {
      if ((_formKey.currentState?.validate() ?? false) &&
          state.newPassword.isNotEmpty &&
          state.confirmPassword.isNotEmpty &&
          state.newPassword == state.confirmPassword) {

        // Check if resetToken is available
        if (state.resetToken == null || state.resetToken!.isEmpty) {
          throw Exception('重設密碼驗證已失效，請重新開始');
        }

        // Check if memberId is available
        if (state.memberId == null || state.memberId!.isEmpty) {
          throw Exception('重設密碼驗證已失效，請重新開始');
        }

        // Check if resetToken is expired
        if (state.resetTokenExpiresAt != null &&
            DateTime.now().isAfter(state.resetTokenExpiresAt!)) {
          throw Exception('重設密碼驗證已過期，請重新開始');
        }

        // Call reset password API with memberId and resetToken
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.resetPassword(
          memberId: state.memberId!,
          resetToken: state.resetToken!,
          newPassword: state.newPassword,
        );

        if (!mounted) return;

        // Show success dialog
        if (context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ResetPasswordSuccessAlert(
              onConfirm: () {
                Navigator.of(context).pop();
              },
            ),
          );
        }

        // Log out the user
        if (mounted) {
          await authNotifier.logout();
        }

        // Navigate to login page
        if (context.mounted) {
          context.router.pushAndPopUntilWithTracking(
            LoginRoute(),
            predicate: (_) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        final appLocale = AppLocalizations.of(context);

        // Handle specific error codes
        String errorMessage = e.toString();
        if (errorMessage.contains('10005')) {
          errorMessage = '重設密碼驗證已過期，請重新開始';
        }

        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: errorMessage,
            buttonText: appLocale?.okay ?? "",
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

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final state = ref.watch(forgetPasswordControllerProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 16, 35, 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PasswordBuilderFormField(
                        controller: _newPasswordController,
                        onChanged: (value) {
                          ref
                              .read(forgetPasswordControllerProvider.notifier)
                              .updateNewPassword(value);
                        },
                        mode: PasswordFieldMode.builder,
                        hintText: appLocale?.setNewPassword,
                        labelText: appLocale?.setNewPasswordFieldHint,
                      ),
                      const SizedBox(height: 20),
                      PasswordBuilderFormField(
                        controller: _confirmPasswordController,
                        onChanged: (value) {
                          ref
                              .read(forgetPasswordControllerProvider.notifier)
                              .updateConfirmPassword(value);
                        },
                        mode: PasswordFieldMode.confirm,
                        confirmPassword: state.newPassword,
                        hintText: appLocale?.confirmPasswordFieldHint,
                        labelText: appLocale?.confirmPassword,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AuthButton(
                        onPressed: () async {
                          await _handleNext(context, ref);
                        },
                        label: appLocale?.next ?? "下一步",
                        isEnabled: _isPasswordValid(state.newPassword) &&
                            state.confirmPassword.isNotEmpty &&
                            state.newPassword == state.confirmPassword,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
