import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';

class FPGIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const FPGIcon({super.key, required this.isEnabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0057B7),
      ),
      child: Transform.translate(
        offset: Offset(0,0),
        child: Icon(
          ECOCOIcons.fpg,
          size: size * 0.65,
          color: isEnabled ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
