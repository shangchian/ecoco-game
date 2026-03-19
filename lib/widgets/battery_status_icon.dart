import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class BatteryStatusIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const BatteryStatusIcon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      ECOCOIcons.batteryStatus,
      size: size,
      color: isEnabled ? AppColors.stationGreenBadge : AppColors.stationGrayBadge,
    );
  }
}
