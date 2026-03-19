import 'package:ecoco_app/ecoco_icons.dart';

import '/constants/colors.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class NicknameFormField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool>? onValidationChanged;
  final double fontSize;

  const NicknameFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onValidationChanged,
    this.fontSize = 16.0,
  });

  @override
  State<NicknameFormField> createState() => _NicknameFormFieldState();
}

class _NicknameFormFieldState extends State<NicknameFormField> {
  bool isValid = true;
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

  bool _validateNickname(String value) {
    // Empty is invalid - this is a required field
    if (value.isEmpty) return false;

    // Check length constraint: max 10
    if (value.length > 10) return false;

    // Check format: Chinese, English, numbers, spaces only
    return RegExp(r'^[a-zA-Z0-9\u4e00-\u9fa5\s]+$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    // Determine if field has validation error
    final hasError = (!isValid && widget.controller.text.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL WITH RED ASTERISK
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: appLocale?.nickname ?? "會員名稱",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8), // Spacing between label and field

        // TEXT FORM FIELD (with prefix icon)
        MediaQuery.withNoTextScaling(
          child: TextFormField(
            focusNode: myFocusNode,
            cursorColor: AppColors.textCursorColor,
            controller: widget.controller,
            maxLength: 10, // Character limit
            style: TextStyle(fontSize: widget.fontSize),
            decoration: InputDecoration(     
            filled: true,
            fillColor: Colors.white,
            hintText: appLocale?.nicknameHint ?? '',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(ECOCOIcons.ecocoMan, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            isDense: true,
            constraints: const BoxConstraints(maxHeight: 40),
            counterText: '', // Hide character counter (10/10)

            // BORDER STATES
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: hasError ? AppColors.formFieldErrorBorder : AppColors.inputBorderColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: hasError ? AppColors.formFieldErrorBorder : AppColors.inputBorderColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: hasError ? AppColors.formFieldErrorBorder : Colors.blue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColors.formFieldErrorBorder,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColors.formFieldErrorBorder,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            // Always return null to prevent Flutter from reserving error space
            // Validation is handled by isValid state and checked manually in parent
            return null;
          },
          onChanged: (value) {
            setState(() {
              isValid = _validateNickname(value);
            });
            widget.onValidationChanged?.call(isValid);
            widget.onChanged(value);
          },
          ),
        ),

        const SizedBox(height: 8), // Spacing between field and messages

        // ERROR MESSAGE (conditional - only when invalid)
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    appLocale?.nicknameFormatError ?? "名稱格式不符規定",
                    style: const TextStyle(
                      color: AppColors.formFieldErrorBorder,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // INFO MESSAGE 1 (persistent - always visible)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.secondaryValueColor,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                appLocale?.nicknameInfoCharLimit ?? "限10字內，可輸入中英文、數字或空格",
                style: const TextStyle(
                  color: AppColors.secondaryValueColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8), // Spacing between info messages

        // INFO MESSAGE 2 (persistent - always visible)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.secondaryValueColor,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                appLocale?.nicknameInfoPublicWarning ?? "此名稱將公開顯示，請避免使用不當字詞",
                style: const TextStyle(
                  color: AppColors.secondaryValueColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 