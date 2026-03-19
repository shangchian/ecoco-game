import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class NtpCoinIcon extends StatelessWidget {
  final bool filled;
  final double size;
  final bool isEnabled;

  const NtpCoinIcon({
    super.key,
    required this.isEnabled,
    this.size = 24.0,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!filled) {
      return Icon(
        ECOCOIcons.ntpCoin,
        size: size,
        color: isEnabled ? AppColors.ntpCoinColor : AppColors.secondaryValueColor,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEnabled ? AppColors.ntpCoinColor : AppColors.secondaryValueColor,
      ),
      child: Transform.translate(
        offset: Offset((size * 0), (size * 0)),
        child: Icon(
          ECOCOIcons.ntpCircle,
          size: size,
          color: Colors.white,
        ),
      ),
    );
  }
}
