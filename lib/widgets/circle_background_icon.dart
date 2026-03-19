import 'package:flutter/material.dart';

class CircleBackgroundIcon extends StatelessWidget {
  final dynamic icon;
  final bool isEnabled;
  final double? size;
  final Color backgroundColor;
  final bool isImage;

  const CircleBackgroundIcon({
    super.key,
    required this.icon,
    required this.isEnabled,
    this.size = 24.0,
    this.backgroundColor = const Color(0xFFFF5000),
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: isImage
          ? Image.asset(
              icon as String,
              width: size! * 0.6,
              height: size! * 0.6,
              color: isEnabled ? Colors.white : Colors.grey,
            )
          : Icon(
              icon as IconData,
              size: size! * 0.9,
              color: isEnabled ? Colors.white : Colors.grey,
            ),
    );
  }
}
