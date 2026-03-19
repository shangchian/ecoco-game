import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/activity_model.dart';
import '../../../../providers/coupon_rules_provider.dart';
import '../../../../providers/wallet_provider.dart';
import 'package:ecoco_app/router/app_router.dart';
import '../../../../widgets/activity_card.dart';
import '/utils/router_analytics_extension.dart';

class ActivitySection extends ConsumerWidget {
  const ActivitySection({super.key});

  // Mock activity data
  List<ActivityModel> _getMockActivities() {
    return [
      // ActivityModel(
      //   id: '1',
      //   title: '加碼贈新北幣',
      //   subtitle: '新北市限定任務獎勵',
      //   iconUrl: 'assets/images/ntp.webp',
      //   couponRuleId: '152778046385033216',
      // ),
      ActivityModel(
        id: '1',
        title: '台泥DAKA園區',
        subtitle: '紀念幣',
        iconUrl: 'assets/images/daka_promo.png',
        couponRuleId: '83533005280247808',
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = _getMockActivities();
    final walletData = ref.watch(walletProvider);
    final userPoints = walletData?.dakaWallet.currentBalance ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              const Icon(
                ECOCOIcons.campaign,
                size: 24,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '活動專區',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Activity cards in vertical list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Column(
              children: List.generate(
                activities.length * 2 - 1,
                (index) {
                  if (index.isOdd) {
                    // Divider between cards
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 0.5,
                        color: Colors.grey.shade300,
                      ),
                    );
                  } else {
                    // Activity card
                    final activityIndex = index ~/ 2;
                    final activity = activities[activityIndex];
                    return ActivityCard(
                      activity: activity,
                      onTap: () async {
                        final couponRuleId = activity.couponRuleId;
                        if (couponRuleId == null) return;

                        final couponRule = await ref.read(
                          couponRuleByIdProvider(couponRuleId).future,
                        );
                        if (couponRule == null || !context.mounted) return;

                        context.router.pushThrottledWithTracking(
                          MerchantRewardExchangeRoute(
                            couponRule: couponRule,
                            userPoints: userPoints,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 150),
      ],
    );
  }
}
