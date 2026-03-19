import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class ThreeBottlesStatusIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const ThreeBottlesStatusIcon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Estimated aspect ratio for three bottles icon (wider than square)
    // The icon shows 3 bottles side-by-side, making it wider than tall
    const double aspectRatio = 1.7; // width / height

    return SizedBox(
      width: size != null ? size! * aspectRatio : null,
      height: size,
      child: Icon(
        ECOCOIcons.threeBottles,
        size: size,
        color: isEnabled ? Colors.green : Colors.grey,
      ),
    );
  }
}
