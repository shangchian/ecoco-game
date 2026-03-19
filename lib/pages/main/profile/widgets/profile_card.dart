import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '/providers/avatar_provider.dart';
import '/providers/profile_provider.dart';
import '/providers/recycling_stats_provider.dart';
import '/models/recycling_period_stats.dart';
import '/utils/phone_utils.dart';
import '/router/app_router.dart';
import 'recycling_statistics_card.dart';
import 'dart:typed_data';
import '/utils/router_analytics_extension.dart';

class ProfileCard extends ConsumerWidget {
  final int points;
  final double co2Reduction;

  const ProfileCard({
    super.key,
    required this.points,
    required this.co2Reduction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileProvider);
    final recyclingStats = ref.watch(recyclingStatsProvider);

    final memberName = profileData?.nickname ?? '會員名稱';
    final memberId = PhoneUtils.getLastFourDigits(profileData?.phone);

    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Avatar, Verified Badge, and Member Name
            Row(
              children: [
                // Avatar
                Consumer(
                  builder: (context, ref, child) {
                    final avatarState = ref.watch(avatarProvider);

                    if (avatarState.isLoading) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const CircularProgressIndicator(
                          color: AppColors.primaryHighlightColor,
                        ),
                      );
                    }

                    if (avatarState.imageBytes != null) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.memory(
                            Uint8List.fromList(avatarState.imageBytes!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      width: 62,
                      height: 62,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/ecoco_avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to icon if asset fails to load
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                // Verified Badge and Member Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.secondaryTextColor,
                            width: 1,
                          ),
                        ),
                        child: SizedBox(
                          //width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '已驗證 #$memberId',
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            memberName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 回收統計卡片 (新的獨立Widget)
            RecyclingStatisticsCard(
              monthlyStats: recyclingStats?.monthly ?? getMockMonthlyStats(),
              yearlyStats: recyclingStats?.yearly ?? getMockYearlyStats(),
              totalStats: recyclingStats?.total ?? getMockTotalStats(),
              onViewHistory: () {
                context.router.pushThrottledWithTracking(const PointsHistoryRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
