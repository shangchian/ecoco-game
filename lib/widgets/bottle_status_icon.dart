import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class BottleStatusIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const BottleStatusIcon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      ECOCOIcons.bottleStatus,
      size: size,
      color: isEnabled ? AppColors.stationGreenBadge : AppColors.stationGrayBadge,
    );
  }
}
