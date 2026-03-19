import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/colors.dart';
import '/providers/coupon_rules_provider.dart';
import '/providers/wallet_provider.dart';
import 'merchant_reward_exchange_page.dart';

/// 透過 couponRuleId 載入 CouponRule 後顯示 MerchantRewardExchangePage
/// 用於 Deep Link / Universal Link 導航
@RoutePage()
class MerchantRewardExchangeByIdPage extends ConsumerWidget {
  final String couponRuleId;

  const MerchantRewardExchangeByIdPage({
    super.key,
    @PathParam('couponRuleId') required this.couponRuleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponRuleAsync = ref.watch(couponRuleByIdProvider(couponRuleId));
    final walletData = ref.watch(walletProvider);

    return couponRuleAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryHighlightColor,
            )
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                '無法載入優惠資訊',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.router.maybePop(),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      ),
      data: (couponRule) {
        if (couponRule == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.card_giftcard_outlined,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    '找不到此優惠',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.maybePop(),
                    child: const Text('返回'),
                  ),
                ],
              ),
            ),
          );
        }

        // 取得使用者點數
        final userPoints = walletData?.ecocoWallet.currentBalance ?? 0;

        // 成功載入 CouponRule，顯示實際的 MerchantRewardExchangePage
        return MerchantRewardExchangePage(
          couponRule: couponRule,
          userPoints: userPoints,
        );
      },
    );
  }
}
