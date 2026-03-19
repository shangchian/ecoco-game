import 'package:flutter/material.dart';
import '../ecoco_icons.dart';
import 'circle_background_icon.dart';

class ToolIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const ToolIcon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CircleBackgroundIcon(
      icon: ECOCOIcons.tool,
      isEnabled: isEnabled,
      size: size,
      backgroundColor: Color(0xFF34C759),
    );
  }
}
