import 'package:flutter/material.dart';

/// 自訂的 Locker 圖標繪製器
class LockerPainter extends CustomPainter {
  final Color color;

  LockerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 加入 padding 讓 icon 不要填滿整個空間
    final padding = size.width * 0.25; // 25% padding
    final availableHeight = size.height - (padding * 2);

    // 根據 SVG viewBox 比例計算實際尺寸
    // viewBox: 4.233 x 5.556 (寬高比約 0.76)
    final scale = availableHeight / 5.556;

    // SVG 實際尺寸（基於 viewBox）
    final iconWidth = 4.233 * scale;
    final iconHeight = 5.556 * scale;
    final offsetX = (size.width - iconWidth) / 2;
    final offsetY = (size.height - iconHeight) / 2;

    // 鎖扣參數（基於 SVG 的 1.3224 半徑圓角矩形）
    final shackleWidth = 1.3224 * scale; // 鎖扣的寬度（半寬）
    final shackleHeight = 1.3224 * scale; // 鎖扣的高度（半徑）
    final shackleThickness = 0.529 * scale; // 鎖扣線條粗細
    final shackleExtension = 0.5271 * scale; // 鎖扣向下延伸

    // 鎖身參數
    final bodyWidth = 2.6448 * scale;
    final bodyHeight = 2.117 * scale;
    final bodyRadius = 0.266 * scale; // 外圓角
    final bodyInnerRadius = 0.176 * scale; // 內圓角

    // 中心點
    final centerX = offsetX + iconWidth / 2;
    final topY = offsetY;

    // 鎖身起始 Y 位置
    final bodyY = topY + shackleHeight + shackleExtension;

    // 1. 繪製鎖扣（U 型）
    final shacklePath = Path();

    // 鎖扣外圓半徑
    final outerRadius = shackleWidth;
    // 鎖扣內圓半徑
    final innerRadius = shackleWidth - shackleThickness;

    // 起點：左下角外側
    shacklePath.moveTo(centerX - shackleWidth, topY + shackleHeight);

    // 左側向下延伸
    shacklePath.lineTo(centerX - shackleWidth, topY + shackleHeight + shackleExtension);

    // 移動到左側內側底部
    shacklePath.lineTo(centerX - shackleWidth + shackleThickness, topY + shackleHeight + shackleExtension);

    // 左側內側向上
    shacklePath.lineTo(centerX - shackleWidth + shackleThickness, topY + shackleHeight);

    // 內圓弧（逆時針從左到右）
    shacklePath.arcToPoint(
      Offset(centerX + shackleWidth - shackleThickness, topY + shackleHeight),
      radius: Radius.circular(innerRadius),
      clockwise: false,
    );

    // 右側內側向下
    shacklePath.lineTo(centerX + shackleWidth - shackleThickness, topY + shackleHeight + shackleExtension);

    // 移動到右側外側底部
    shacklePath.lineTo(centerX + shackleWidth, topY + shackleHeight + shackleExtension);

    // 右側外側向上
    shacklePath.lineTo(centerX + shackleWidth, topY + shackleHeight);

    // 外圓弧（順時針從右到左）
    shacklePath.arcToPoint(
      Offset(centerX - shackleWidth, topY + shackleHeight),
      radius: Radius.circular(outerRadius),
      clockwise: false,
    );

    shacklePath.close();
    canvas.drawPath(shacklePath, paint);

    // 2. 繪製鎖身（外圓角矩形）
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, bodyY + bodyHeight / 2),
        width: bodyWidth,
        height: bodyHeight,
      ),
      Radius.circular(bodyRadius),
    );
    canvas.drawRRect(bodyRRect, paint);

    // 3. 繪製鎖身內部（挖空 - 白色圓角矩形）
    final innerBodyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final innerBodyWidth = bodyWidth - bodyRadius * 2;
    final innerBodyHeight = bodyHeight - bodyRadius * 2;

    final innerBodyRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, bodyY + bodyHeight / 2),
        width: innerBodyWidth,
        height: innerBodyHeight,
      ),
      Radius.circular(bodyInnerRadius),
    );
    canvas.drawRRect(innerBodyRRect, innerBodyPaint);

    // 4. 繪製鎖孔
    final keyholeRadius = 0.2646 * scale;
    final keyholeRectHeight = 0.793 * scale;
    final keyholeY = bodyY + bodyHeight * 0.31;

    // 鎖孔圓形
    canvas.drawCircle(
      Offset(centerX, keyholeY),
      keyholeRadius,
      paint,
    );

    // 鎖孔矩形（向下）
    final keyholeRectWidth = keyholeRadius * 2;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, keyholeY + keyholeRectHeight / 2),
        width: keyholeRectWidth,
        height: keyholeRectHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(LockerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Locker 圖標 Widget
class LockerIcon extends StatelessWidget {
  final bool isEnabled;
  final double? size;
  final Color? color;

  const LockerIcon({
    super.key,
    required this.isEnabled,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isEnabled
        ? (color ?? const Color(0xFF808080))
        : Colors.grey;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: LockerPainter(color: iconColor),
      ),
    );
  }
}
