import 'package:ecoco_app/pages/common/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/verify_otp_response_model.dart';
import '/providers/register/register_provider.dart';
import '/pages/common/form_fields/password_builder_field.dart';
import '/l10n/app_localizations.dart';

class PasswordStep extends ConsumerStatefulWidget {
  final VerifyOtpResponse tempTokens;
  final VoidCallback onNext;

  const PasswordStep({
    super.key,
    required this.tempTokens,
    required this.onNext,
  });

  @override
  ConsumerState<PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends ConsumerState<PasswordStep> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _password = '';
  String _confirmPassword = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[a-zA-Z]'))) return false;
    return true;
  }

  bool _isFormValid() {
    final register = ref.read(registerProvider);
    if (register.isLoading) return false;
    if (!_isPasswordValid(_password)) return false;
    if (_confirmPassword.isEmpty) return false;
    if (_password != _confirmPassword) return false;
    return true;
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(registerProvider.notifier);
      notifier.updatePassword(_password);
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // 密碼輸入欄位
              PasswordBuilderFormField(
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                mode: PasswordFieldMode.builder,
                hintText: appLocale?.setNewPassword ?? '',
              ),
              const SizedBox(height: 24),

              // 確認密碼輸入欄位
              PasswordBuilderFormField(
                controller: _confirmPasswordController,
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                labelText: appLocale?.confirmPassword ?? '',
                hintText: appLocale?.confirmPasswordFieldHint ?? '',
                mode: PasswordFieldMode.confirm,
                confirmPassword: _password,
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 32),
              // 下一步按鈕
              AuthButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  _handleNext();
                },
                label: appLocale?.next ?? "下一步",
                isEnabled: _isFormValid(),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
