import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class EcocoIcon extends StatelessWidget {
  final double size;
  final Color? color;

  // 預設向上偏移 size 的 5% 來修正字體底部空白
  static const double _defaultOffsetRatio = 0.05;

  const EcocoIcon({
    super.key,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Transform.translate(
        offset: Offset(0, (size * _defaultOffsetRatio)),
        child: Icon(
          ECOCOIcons.ecoco,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
