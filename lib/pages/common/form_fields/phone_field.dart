import 'dart:io';

import 'package:ecoco_app/widgets/smartphone_icon.dart';

import '/constants/colors.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class PhoneFormField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool isPhoneRegistered;

  const PhoneFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
    this.isPhoneRegistered = false,
  });

  @override
  State<PhoneFormField> createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  bool validateFormat = true;
  bool isEditing = false;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      setState(() {
        isEditing = myFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final showWarning = _shouldShowWarning();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          enabled: widget.enabled,
          style: const TextStyle(fontSize: 16),
          keyboardType: Platform.isIOS
              ? const TextInputType.numberWithOptions(signed: false, decimal: false)
              : TextInputType.number,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumber],
          onFieldSubmitted: (value) => myFocusNode.unfocus(),
          cursorColor: AppColors.textCursorColor,
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxHeight: 40),
            filled: true,
            fillColor: Colors.white,
            hintText: appLocale?.phoneHint ?? '輸入手機門號',
            hintStyle: const TextStyle(color: Colors.grey),
            //prefixIcon: const Icon(Icons.smartphone, color: Colors.grey),
            prefixIcon: const SmartphoneIcon(isEnabled: false),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: showWarning? AppColors.formFieldErrorBorder: AppColors.inputBorderColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: showWarning? AppColors.formFieldErrorBorder:AppColors.inputBorderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: showWarning? AppColors.formFieldErrorBorder:AppColors.inputBorderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: showWarning? AppColors.formFieldErrorBorder:Colors.blue, width: 2),
            ),
          ),
          onChanged: _handlePhoneChange,
        ),
        if (showWarning)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _getWarningMessage(appLocale),
                    style: const TextStyle(color: AppColors.formFieldErrorBorder, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _handlePhoneChange(String value) {
    if (!widget.enabled) return; // 如果禁用，不處理變更

    String newVal = value.replaceAll(RegExp(r'[^0-9]'), '');
    newVal = newVal.startsWith('886')
        ? newVal.replaceFirst('886', '0')
        : newVal;
    newVal = newVal.length > 10 ? newVal.substring(0, 10) : newVal;
    setState(() {
      // 只要有輸入內容就進行格式驗證
      // validateFormat = RegisterValidator.validatePhoneFormat(newVal);
      validateFormat = newVal.length == 10;
      widget.controller.value = TextEditingValue(
        text: newVal,
        selection: TextSelection.collapsed(offset: newVal.length),
      );
    });
    widget.onChanged(newVal);
  }

  bool _shouldShowWarning() {
    // Don't show warning if field is empty
    if (widget.controller.text.isEmpty) return false;

    // Show warning if phone is already registered or format is invalid
    return widget.isPhoneRegistered || !validateFormat;
  }

  String _getWarningMessage(AppLocalizations? appLocale) {
    // Priority: registered error > format error
    if (widget.isPhoneRegistered) {
      return appLocale?.phoneAlreadyRegistered ?? "該門號已被註冊";
    }
    if (!validateFormat) {
      return appLocale?.phoneFormatInvalid ?? "請輸入有效的號碼，例：0912345678";
    }
    return "";
  }
}
