import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/constants/colors.dart';
import '/router/app_router.dart';

class FavoriteEmptyState extends StatelessWidget {
  const FavoriteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with map pin and star
          Image.asset(
            'assets/images/fav_location_pin.png',
            width: 105,
            height: 138,
          ),
          const SizedBox(height: 24),

          // Main message
          const Text(
            '暫無常用站點',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryValueColor,
            ),
          ),
          const Text(
            '現在就去收藏吧！',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryValueColor,
            ),
          ),
          const SizedBox(height: 32),

          // Button to go to sites page
          ElevatedButton(
            onPressed: () {
              // Navigate to MainRoute with Sites tab active
              context.router.navigate(
                MainRoute(children: [SiteRoute(onLoadingChanged: (_) {})]),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryHighlightColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              '前往站點頁',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
