import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class MilkBottleStatusIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const MilkBottleStatusIcon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      ECOCOIcons.milkBottleStatus,
      size: size,
      color: isEnabled ? AppColors.stationGreenBadge : AppColors.stationGrayBadge,
    );
  }
}
