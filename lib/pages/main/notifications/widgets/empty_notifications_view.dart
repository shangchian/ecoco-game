import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';

class EmptyNotificationsView extends StatelessWidget {
  const EmptyNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ECOCOIcons.bell,
            size: 155,
            color: AppColors.greyBackground
          ),
          const SizedBox(height: 16),
          Text(
            '目前沒有任何消息喔！',
            style: TextStyle(
              color: AppColors.secondaryValueColor,
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
