import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class SerialIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const SerialIcon({super.key, required this.isEnabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF8EB8C9),
      ),
      child: Transform.translate(
        offset: Offset(-2, 0),
        child: Icon(
          ECOCOIcons.serialExchange,
          size: size * 0.5,
          color: isEnabled ? Colors.white : Colors.grey,
      )),
    );
  }
}
