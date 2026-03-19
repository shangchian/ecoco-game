import 'package:flutter/material.dart';
import '../ecoco_icons.dart';

class CouponRedeemIcon extends StatelessWidget {
  final bool isEnabled;
  final double size;

  const CouponRedeemIcon({super.key, required this.isEnabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1DBDAC),
      ),
      child: Icon(
          ECOCOIcons.ticketFolder,
          size: size * 0.6,
          color: isEnabled ? Colors.white : Colors.grey,
      ),
    );
  }
}
