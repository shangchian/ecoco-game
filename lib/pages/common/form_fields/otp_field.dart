import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '/constants/colors.dart';
import '/l10n/app_localizations.dart';

class OTPFormField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool autofocus;
  final TextEditingController? controller;
  final bool useTextField;
  final FocusNode? focusNode;
  final bool isOtpIncorrect;

  const OTPFormField({
    super.key,
    required this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.controller,
    this.useTextField = false,
    this.focusNode,
    this.isOtpIncorrect = false,
  });

  @override
  State<OTPFormField> createState() => _OTPFormFieldState();
}

class _OTPFormFieldState extends State<OTPFormField> {
  String _currentOTP = '';
  bool _isFormatValid = true;
  bool _hasNonNumericChars = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: widget.useTextField
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: const TextSelectionThemeData(
                              cursorColor: AppColors.textCursorColor,
                            ),
                          ),
                          child: TextFieldPinAutoFill(
                            currentCode: _currentOTP,
                            focusNode: widget.focusNode,
                            decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: const Icon(ECOCOIcons.shield, color: Colors.grey),
                              constraints: const BoxConstraints(maxHeight: 40),
                              hintText: appLocale?.otpHint2 ?? "",
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: _shouldShowWarning()? AppColors.formFieldErrorBorder : AppColors.inputBorderColor, width: 2),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: _shouldShowWarning()? AppColors.formFieldErrorBorder : AppColors.inputBorderColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: _shouldShowWarning()? AppColors.formFieldErrorBorder : AppColors.inputBorderColor, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: _shouldShowWarning()? AppColors.formFieldErrorBorder : Colors.blue, width: 2),
                              ),
                            ),
                            onCodeChanged: (code) {
                              setState(() {
                                _currentOTP = code;
                                _isFormatValid = _validateOtpFormat(code);
                              });
                              widget.onChanged(code);
                            },
                            codeLength: 6,
                          ),
                        ),
                      ],
                    )
                  : PinFieldAutoFill(
                      currentCode: _currentOTP,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      decoration: BoxLooseDecoration(
                        textStyle: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w800
                        ),
                        radius: Radius.circular(16),
                        strokeColorBuilder:
                            _shouldShowWarning() ? 
                            PinListenColorBuilder(AppColors.formFieldErrorBorder, AppColors.formFieldErrorBorder) : 
                            PinListenColorBuilder(AppColors.greyBackground, AppColors.greyBackground),
                        bgColorBuilder: PinListenColorBuilder(
                          AppColors.greyBackground,
                          AppColors.greyBackground,
                        ),
                      ),
                      onCodeChanged: (code) {
                        setState(() {
                          _currentOTP = code ?? '';
                          _isFormatValid = _validateOtpFormat(code ?? '');
                        });
                        widget.onChanged(code ?? '');
                      },
                      codeLength: 6,
                    ),
            ),
          ],
        ),
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
                    style: const TextStyle(color: AppColors.formFieldErrorBorder, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _validateOtpFormat(String otp) {
    if (otp.isEmpty) return true; // Don't show error for empty field

    // Check for non-numeric characters first
    _hasNonNumericChars = !RegExp(r'^[0-9]*$').hasMatch(otp);
    if (_hasNonNumericChars) return false;

    // Then check length
    return otp.length == 6;
  }

  bool _shouldShowWarning() {
    // Don't show warning if field is empty
    if (_currentOTP.isEmpty) return false;

    if (_hasNonNumericChars) {
      return true;
    }

    if (!_isFormatValid && widget.useTextField) {
      return false;
    }

    // Show warning if OTP is incorrect or format is invalid
    return widget.isOtpIncorrect || !_isFormatValid;
  }

  String _getWarningMessage(AppLocalizations? appLocale) {
    // Priority: incorrect error > non-numeric error > format error
    if (widget.isOtpIncorrect) {
      return appLocale?.otpIncorrect ?? "驗證碼輸入錯誤，請重新輸入";
    }
    if (_hasNonNumericChars) {
      return appLocale?.otpNumericOnly ?? "請輸入數字驗證碼";
    }
    if (!_isFormatValid && !widget.useTextField) {
      return appLocale?.otpFormatInvalid ?? "驗證碼為6碼，請重新輸入";
    }
    return "";
  }
}
