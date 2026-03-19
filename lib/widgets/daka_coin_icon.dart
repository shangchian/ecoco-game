import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class DakaCoinIcon extends StatelessWidget {
  final bool filled;
  final double size;
  final bool isEnabled;

  const DakaCoinIcon({
    super.key,
    required this.isEnabled,
    this.size = 24.0,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!filled) {
      return Icon(
        ECOCOIcons.dakaCoin,
        size: size,
        color: isEnabled ? AppColors.dakaCoinColor : AppColors.secondaryValueColor,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEnabled ? AppColors.dakaCoinColor : AppColors.secondaryValueColor,
      ),
      child: Transform.translate(
        offset: Offset((size * 0.02), (size * 0.08)),
        child: Icon(
          ECOCOIcons.dakaDiamond,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
