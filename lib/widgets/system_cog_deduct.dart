import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class SystemCogDeductIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const SystemCogDeductIcon({super.key, required this.isEnabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD65B73),
      ),
      child: Icon(
          ECOCOIcons.systemCog,
          size: size * 0.65,
          color: isEnabled ? Colors.white : Colors.grey,
      ),
    );
  }
}
