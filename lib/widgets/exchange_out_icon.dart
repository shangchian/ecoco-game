import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class ExchangeOutIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const ExchangeOutIcon({super.key, required this.isEnabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF00A82D),
      ),
      child: Icon(
          ECOCOIcons.dakaStone,
          size: size * 0.8,
          color: isEnabled ? Colors.white : Colors.grey,
      ),
    );
  }
}
