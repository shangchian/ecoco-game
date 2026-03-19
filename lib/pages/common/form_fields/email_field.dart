import 'package:ecoco_app/ecoco_icons.dart';

import '/constants/colors.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class EmailFormField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onValidationChanged;
  final double fontSize;

  const EmailFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.onValidationChanged,
    this.fontSize = 16.0,
  });

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  bool isValid = true;
  bool isEditing = false;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = widget.focusNode ?? FocusNode();
    myFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      isEditing = myFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    myFocusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      myFocusNode.dispose();
    }
    super.dispose();
  }

  bool _validateEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) || value.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final hasError = !isValid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaQuery.withNoTextScaling(
          child: TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          cursorColor: AppColors.textCursorColor,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          style: TextStyle(fontSize: widget.fontSize),
          decoration: InputDecoration(
            isDense: true,
            constraints: const BoxConstraints(maxHeight: 40),
            filled: true,
            fillColor: Colors.white,
            hintText: appLocale?.emailHint ?? '',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(ECOCOIcons.markEmailUnread, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
            )
          ),
          onChanged: (value) {
            setState(() {
              isValid = _validateEmail(value);
            });
            widget.onValidationChanged?.call(isValid);
            widget.onChanged(value);
          },
        )),
        if (_shouldShowWarning())
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _getWarningMessage(appLocale),
                    style: const TextStyle(
                      color: AppColors.formFieldErrorBorder,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _shouldShowWarning() {
    // Don't show warning if field is empty
    if (widget.controller.text.isEmpty) return false;

    // Show warning if email format is invalid
    return !isValid;
  }

  String _getWarningMessage(AppLocalizations? appLocale) {
    if (!isValid) {
      return appLocale?.emailErrorContent ?? '無效的格式，請重新輸入';
    }
    return '';
  }
} 