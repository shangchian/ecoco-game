import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class SubscribeNewsField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const SubscribeNewsField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => onChanged(!value),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value ? AppColors.orangeBackground : Colors.grey,
                    width: 2,
                  ),
                  color: value ? AppColors.orangeBackground : Colors.white,
                ),
                child: value
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        size: 16,
                      )
                    : null,
              ),
            ),
            SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              width: 280,
              child: Text(appLocale?.subscribeNews ?? '', style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryTextColor,
              ),),
            ),
          ],
        ),
      ),
    );
  }
} 