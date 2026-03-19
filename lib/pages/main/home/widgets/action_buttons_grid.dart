import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../router/app_router.dart';
import '../../../../providers/voucher_seen_provider.dart';
import '/utils/snackbar_helper.dart';
import 'action_button.dart';
import '/utils/router_analytics_extension.dart';

class ActionButtonsGrid extends ConsumerWidget {
  const ActionButtonsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnseenVouchers = ref.watch(unseenActiveVouchersCountProvider) > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Voucher Area (票券匣)
          Expanded(
            child: ActionButton(
              icon: ECOCOIcons.ticketFolder,
              label: '我的票券',
              iconSize: 27,
              showBadge: hasUnseenVouchers,
              onTap: () {
                context.router.pushThrottledWithTracking(VoucherWalletRoute());
              },
            ),
          ),
          const SizedBox(width: 12),
          // Points History (點數歷程)
          Expanded(
            child: ActionButton(
              icon: ECOCOIcons.pointHistory,
              label: '點數歷程',
              onTap: () {
                context.router.pushThrottledWithTracking(const PointsHistoryRoute());
              }, // Not implemented yet
            ),
          ),
          const SizedBox(width: 12),
          // Favorite Stations (常用站點)
          Expanded(
            child: ActionButton(
              icon: ECOCOIcons.favStation,
              label: '常用站點',
              onTap: () {
                context.router.pushThrottledWithTracking(const FavoriteSitesRoute());
              }, // Not implemented yet
              iconSize: 31,
            ),
          ),
          const SizedBox(width: 12),
          // Code Redemption (序號兌換)
          Expanded(
            child: ActionButton(
              icon: ECOCOIcons.serialExchange,
              label: '序號兌換',
              onTap: () {
                SnackBarHelper.show(context, '功能開發中，敬請期待！',
                  margin: const EdgeInsets.only(
                      bottom: 40, left: 16, right: 16),
                );
              }, // Not implemented yet
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
