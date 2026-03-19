import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LocationPermissionBanner extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onClose;

  const LocationPermissionBanner({
    super.key,
    required this.onSettingsTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryValueColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: '尚未開啟定位，'),
                  TextSpan(
                    text: '前往設定',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onSettingsTap,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
