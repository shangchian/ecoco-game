import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

/// Smartphone 圖標 Widget
class SmartphoneIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;
  final Color? color;

  const SmartphoneIcon({
    super.key,
    required this.isEnabled,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isEnabled
        ? (color ?? const Color(0xFF757575))
        : Colors.grey;

    return Icon(
      ECOCOIcons.smartphone,
      size: size,
      color: iconColor,
    );
  }
}
