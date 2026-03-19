import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class ExchangeIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const ExchangeIcon({super.key, required this.isEnabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFF5000),
      ),
      child: Icon(
          ECOCOIcons.dakaStone,
          size: size * 0.8,
          color: isEnabled ? Colors.white : Colors.grey,
      ),
    );
  }
}
