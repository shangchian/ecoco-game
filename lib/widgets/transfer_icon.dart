import 'package:flutter/material.dart';
import '../ecoco_icons.dart';
import 'circle_background_icon.dart';

class TransferIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;

  const TransferIcon({
    super.key,
    required this.isEnabled,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CircleBackgroundIcon(
      icon: ECOCOIcons.transfer,
      isEnabled: isEnabled,
      size: size,
      backgroundColor: Color(0xFFAAAAAA),
    );
  }
}
