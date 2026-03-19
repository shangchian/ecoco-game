import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class BatteryIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const BatteryIcon({
    super.key,
    required this.isEnabled,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFCE00),
      ),
      child: Transform.translate(
        offset: Offset(-(size*0.25), -(size*0.25)),
        child: Icon(
          ECOCOIcons.battery,
          size: size * 1.5,
          color: isEnabled ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
