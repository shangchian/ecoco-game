import 'package:flutter/material.dart';
import '../ecoco_icons.dart';
import 'circle_background_icon.dart';

class CO2Icon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const CO2Icon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CircleBackgroundIcon(
      icon: ECOCOIcons.co2,
      isEnabled: isEnabled,
      size: size,
    );
  }
}
