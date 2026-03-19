import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/utils/phone_utils.dart';
import 'package:ecoco_app/widgets/ecoco_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ecoco_icons.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../providers/recycling_stats_provider.dart';
import '../../../../providers/wallet_provider.dart';

class UserInfoCard extends ConsumerWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileProvider);
    final walletData = ref.watch(walletProvider);
    final recyclingStats = ref.watch(recyclingStatsProvider);

    final memberName = profileData?.nickname ?? '會員名稱';
    final memberId = PhoneUtils.getLastFourDigits(profileData?.phone);
    final ecocoPoints = walletData?.ecocoWallet.currentBalance ?? 0;

    final co2Reduction = recyclingStats?.total.yearlyCO2 ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/membercard_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Avatar, Name, and Member ID
            Row(
              children: [
                // Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: profileData?.avatarUrl?.isNotEmpty == true
                      ? ClipOval(
                          child: Image.network(
                            profileData!.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/ecoco_avatar.png',
                                width: 62,
                                height: 62,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            'assets/images/ecoco_avatar.png',
                            width: 62,
                            height: 62,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Name and Member ID
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
                            color: AppColors.secondaryValueColor,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryValueColor,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Bottom section: Points and CO2 reduction
            Row(
              children: [
                // ECOCO Points
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EcocoIcon(size: 18),
                          const SizedBox(width: 4),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: const Text(
                                'ECOCO點數',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            ecocoPoints.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.secondaryTextColor,
                ),
                const SizedBox(width: 16),
                // CO2 Reduction
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ECOCOIcons.co2Filled,
                            size: 18,
                            color: AppColors.secondaryTextColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: const Text(
                                '累積減碳量/KG',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            co2Reduction.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
