import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/wallet_provider.dart';
import '/widgets/ecoco_points_badge.dart';

/// 使用者積分頭部元件
/// 顯示使用者大頭貼、名稱和 ECOCO 點數
class UserPointsHeader extends ConsumerWidget {
  const UserPointsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(walletProvider);
    final points = walletData?.ecocoWallet.currentBalance ?? 0;

    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.backgroundYellow, AppColors.backgroundYellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        //borderRadius: BorderRadius.circular(16),
        /* boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],*/
      ),
      child: Row(
        children: [
          // 使用者名稱
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '歡迎回來，',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  '會員名稱Abcd',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // ECOCO 點數標籤
          EcocoPointsBadge.detailed(
            points: points,
          ),
        ],
      ),
    );
  }
}
