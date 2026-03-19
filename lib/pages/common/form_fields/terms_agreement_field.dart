import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/widgets/terms_and_privacy_dialog.dart';

class TermsAgreementField extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsAgreementField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TermsAgreementField> createState() => _TermsAgreementFieldState();
}

class _TermsAgreementFieldState extends State<TermsAgreementField> {
  Future<bool?> _showTermsAndPrivacyDialog(BuildContext context) async {
    return await TermsAndPrivacyDialog.show(
      context,
      requireScrollToBottom: true,
    );
  }

  Future<void> _handleCheckboxChange(bool? newValue) async {
    if (newValue == true && !widget.value) {
      // 試圖勾選時，先顯示 Dialog
      final confirmed = await _showTermsAndPrivacyDialog(context);
      if (confirmed == true) {
        // 使用者確認後才勾選
        widget.onChanged(true);
      }
      // 如果取消或未確認，不呼叫 onChanged，保持原狀
    } else {
      // 取消勾選時直接執行
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return CheckboxListTile(
      value: widget.value,
      onChanged: _handleCheckboxChange,
      title: Text.rich(
        TextSpan(
          text: appLocale?.termsAgreementPrefix ?? '',
          children: [
            TextSpan(
              text: appLocale?.termsOfService ?? '',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _showTermsAndPrivacyDialog(context),
            ),
          ],
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      checkboxShape: CircleBorder(),
      checkColor: Colors.white,
      activeColor: Colors.black,
    );
  }
}
