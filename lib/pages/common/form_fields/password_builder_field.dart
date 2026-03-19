import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

enum PasswordFieldMode {
  simple, // 用於登入頁面，不做驗證
  builder, // 用於建立密碼，需要格式驗證
  confirm // 用於確認密碼
}

class PasswordBuilderFormField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final String? hintText;
  final PasswordFieldMode mode;
  final String? confirmPassword;
  final bool labelTextStar;

  const PasswordBuilderFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.mode = PasswordFieldMode.simple,
    this.confirmPassword,
    this.labelTextStar = false,
  });

  @override
  State<PasswordBuilderFormField> createState() =>
      _PasswordBuilderFormFieldState();
}

class _PasswordBuilderFormFieldState extends State<PasswordBuilderFormField> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get validateFormat {
    switch (widget.mode) {
      case PasswordFieldMode.simple:
        return true;
      case PasswordFieldMode.confirm:
        return (confirmValidate(widget.controller.text) == null ||
            widget.controller.text.isEmpty);
      case PasswordFieldMode.builder:
        return (passwordValidator(widget.controller.text) == null ||
            widget.controller.text.isEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: widget.labelTextStar
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.labelText ?? appLocale?.newPasswordLabel ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    if (widget.labelTextStar)
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (!widget.labelTextStar) const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          style: const TextStyle(fontSize: 16),
          cursorColor: AppColors.textCursorColor,
          autofillHints: widget.mode == PasswordFieldMode.simple
              ? const [AutofillHints.password]
              : const [AutofillHints.newPassword],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            constraints: const BoxConstraints(maxHeight: 40),
            hintText: widget.hintText ?? appLocale?.passwordHint ?? '',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            prefixIcon: const Icon(ECOCOIcons.locker, color: Colors.grey),
            suffixIcon: IconButton(
              iconSize: 15,
              icon: Icon(
                _obscureText ? ECOCOIcons.hiddenEye : ECOCOIcons.openeye,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: !validateFormat && widget.controller.text.isNotEmpty
                    ? AppColors.formFieldErrorBorder
                    : AppColors.inputBorderColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: !validateFormat && widget.controller.text.isNotEmpty
                    ? AppColors.formFieldErrorBorder
                    : AppColors.inputBorderColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: !validateFormat && widget.controller.text.isNotEmpty
                    ? AppColors.formFieldErrorBorder
                    : Colors.blue,
                width: 2,
              ),
            ),
          ),
          validator: widget.mode == PasswordFieldMode.simple
              ? null
              : widget.mode == PasswordFieldMode.confirm
                  ? confirmValidate
                  : passwordValidator,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              widget.mode == PasswordFieldMode.simple
                  ? null
                  : widget.mode == PasswordFieldMode.confirm
                      ? confirmValidate
                      : passwordValidator;
            });
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!validateFormat) ...[
              Flexible(
                child: Text(
                  widget.mode == PasswordFieldMode.confirm
                      ? appLocale!.passwordNotMatch
                      : appLocale!.passwordFormatInvalid,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.formFieldErrorBorder,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String? passwordValidator(String? value) {
    final appLocale = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return appLocale?.passwordValidatorEmpty ?? '';
    }
    if (value.length < 8 || value.length > 20) {
      return appLocale?.passwordValidatorLength ?? '';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return appLocale?.passwordValidatorDigit ?? '';
    }
    if (!value.contains(RegExp(r'[a-zA-Z]'))) {
      return appLocale?.passwordValidatorLowercase ?? '';
    }
    // 不強制大寫
    /* if (!value.contains(RegExp(r'[A-Z]'))) {
      return appLocale?.passwordValidatorUppercase ?? '';
    } */
    return null;
  }

  String? confirmValidate(String? value) {
    final appLocale = AppLocalizations.of(context);
    if (value != widget.confirmPassword) {
      return appLocale!.passwordNotMatch;
    }
    return null;
  }
}
