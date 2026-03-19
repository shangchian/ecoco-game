import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../constants/colors.dart';
import '/utils/snackbar_helper.dart';
import '../../../models/voucher_model.dart';
import '../../../models/coupon_rule.dart';
import '../../../models/member_coupon_with_rule.dart';
import '../../../providers/voucher_wallet_provider.dart';
import '../../../providers/voucher_seen_provider.dart';
import '../../../utils/error_messages.dart';
import '../../../providers/member_coupon_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/voucher_card.dart';
import '../../../router/app_router.dart';
import '/utils/router_analytics_extension.dart';

/// 票券夾頁面
@RoutePage()
class VoucherWalletPage extends ConsumerStatefulWidget {
  final VoucherStatus? initialStatus;

  const VoucherWalletPage({
    super.key,
    this.initialStatus,
  });

  @override
  ConsumerState<VoucherWalletPage> createState() => _VoucherWalletPageState();
}

class _VoucherWalletPageState extends ConsumerState<VoucherWalletPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set initial status if provided
    if (widget.initialStatus != null) {
      // Use microtask to avoid building while building
      Future.microtask(() {
        ref.read(selectedVoucherStatusProvider.notifier).setStatus(widget.initialStatus!);
      });
    }

    // 進入頁面時自動同步資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  /// Pull-to-refresh handler
  Future<void> _onRefresh() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final authData = ref.read(authProvider);
      if (authData == null) return;
      final repository = ref.read(memberCouponRepositoryProvider);
      await repository.syncMemberCoupons();
    } catch (e) {
      debugPrint('Error refreshing vouchers: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to status changes to trigger refresh
    ref.listen(selectedVoucherStatusProvider, (previous, next) {
      if (previous != next) {
        _onRefresh();
      }
    });

    final selectedStatus = ref.watch(selectedVoucherStatusProvider);

    // Watch appropriate stream based on selected tab
    final couponsAsync = selectedStatus == VoucherStatus.active
        ? ref.watch(activeCouponsWithRulesProvider)
        : selectedStatus == VoucherStatus.used
            ? ref.watch(usedCouponsWithRulesProvider)
            : ref.watch(expiredCouponsWithRulesProvider);

    final expiringSoonCount = ref.watch(expiringSoonCountProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundYellow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.popUntilRoot(),
        ),
        title: const Text(
          '我的票券',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        color: AppColors.primaryHighlightColor,
        child: CustomScrollView(
          slivers: [
            // Spacing above tabs
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
            // Sticky filter tabs - Always visible
            SliverPersistentHeader(
              pinned: true,
              delegate: _VoucherFilterTabsDelegate(
                selectedStatus: selectedStatus,
                onStatusChanged: (status) {
                  ref
                      .read(selectedVoucherStatusProvider.notifier)
                      .setStatus(status);
                },
              ),
            ),
            // Divider
            const SliverToBoxAdapter(
              child: Divider(height: 2, thickness: 4, color: Color(0xFFF2F2F2)),
            ),
            
            // Content based on AsyncValue
            ...couponsAsync.when(
              data: (coupons) {
                // 如果正在載入中且無資料，顯示 Loading (避免因為 DB 初始為空而直接顯示 Empty State)
                if (coupons.isEmpty && _isLoading) {
                  return [
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryHighlightColor,
                        ),
                      ),
                    ),
                  ];
                }
                return _buildListSlivers(
                  context,
                  selectedStatus,
                  coupons,
                  expiringSoonCount,
                );
              },
              loading: () => [
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryHighlightColor,
                    ),
                  ),
                ),
              ],
              error: (error, stack) => [
                SliverFillRemaining(
                  child: _buildErrorContent(context, error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build the slivers for the list content
  List<Widget> _buildListSlivers(
    BuildContext context,
    VoucherStatus selectedStatus,
    List<MemberCouponWithRule> coupons,
    int expiringSoonCount,
  ) {
    return [
      // Summary text
      SliverToBoxAdapter(
        child: _buildSummaryText(
          selectedStatus,
          coupons.length,
          expiringSoonCount,
        ),
      ),
      // 票券列表
      if (coupons.isEmpty)
        SliverFillRemaining(
          child: Container(
            color: Colors.white,
            child: _buildEmptyState(selectedStatus),
          ),
        )
      else
        DecoratedSliver(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = coupons[index];
                final memberCouponId = item.memberCoupon.memberCouponId;
                final isActiveStatus = item.isActiveStatus;
                final seenIds = ref.watch(voucherSeenProvider);
                final isUnseen =
                    isActiveStatus && !seenIds.contains(memberCouponId);

                return Column(
                  children: [
                    VisibilityDetector(
                      key: Key('voucher_$memberCouponId'),
                      onVisibilityChanged: (info) {},
                      child: VoucherCard(
                        memberCouponWithRule: item,
                        onTap: selectedStatus == VoucherStatus.expired
                            ? () {}
                            : () => _navigateToDetail(context, item),
                        showUnseenBadge: isUnseen,
                      ),
                    ),
                    if (index < coupons.length - 1)
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Color.fromARGB(255, 222, 222, 222),
                      ),
                  ],
                );
              },
              childCount: coupons.length,
            ),
          ),
        ),
      // Three month notice footer for used/expired tabs
      if (selectedStatus != VoucherStatus.active && coupons.isNotEmpty)
        SliverToBoxAdapter(
          child: _buildThreeMonthNotice(),
        ),
      // Safe area padding (white background)
      SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          height: MediaQuery.paddingOf(context).bottom + 20,
        ),
      ),
      // Fill remaining space with white background
      if (coupons.isNotEmpty)
        const SliverFillRemaining(
          hasScrollBody: false,
          child: ColoredBox(color: Colors.white),
        ),
    ];
  }

  /// Navigate to detail page based on coupon type
  void _navigateToDetail(
    BuildContext context,
    MemberCouponWithRule item
  ) {
    final couponRule = item.couponRule;

    ref.read(voucherSeenProvider.notifier).markAsSeen(item.memberCoupon.memberCouponId);

    if (couponRule == null) {
      SnackBarHelper.show(context, '無法載入優惠券詳情');
      return;
    }

    // Navigate based on AssetRedeemType
    switch (couponRule.assetRedeemType) {
      case AssetRedeemType.scanToRedeem:
        // 出示掃碼型
        context.router.pushThrottledWithTracking(
          MerchantRewardTicketQrInfoRoute(
            couponRule: couponRule,
            memberCouponId: item.memberCoupon.memberCouponId,
            userPoints: 0,
            initialStatus: ref.read(selectedVoucherStatusProvider),
          ),
        );
        break;

      case AssetRedeemType.copyCode:
        // 代碼複製型
        context.router.pushThrottledWithTracking(
          MerchantRewardRedemptionCodeRoute(
            couponRule: couponRule,
            memberCouponId: item.memberCoupon.memberCouponId,
            userPoints: 0,
            initialStatus: ref.read(selectedVoucherStatusProvider),
          ),
        );
        break;

      case AssetRedeemType.none:
        // 無操作動作，兌換成功即為 USED 狀態，顯示已使用資訊頁
        context.router.pushThrottledWithTracking(
          VoucherUsedInfoRoute(
            couponRule: couponRule,
            memberCouponWithRule: item,
          ),
        );
        break;
    }
  }

  /// Build error content
  Widget _buildErrorContent(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '載入失敗',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            ErrorMessages.getDisplayMessage('$error'),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(activeCouponsWithRulesProvider);
              ref.invalidate(usedCouponsWithRulesProvider);
              ref.invalidate(expiredCouponsWithRulesProvider);
            },
            child: const Text('重試', style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),),
          ),
        ],
      ),
    );
  }

  /// Build summary text above the list
  Widget _buildSummaryText(
    VoucherStatus selectedStatus,
    int totalCount,
    int expiringSoonCount,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          children: [
            const TextSpan(
              text: '共計 ',
              style: TextStyle(color: AppColors.secondaryTextColor),
            ),
            TextSpan(
              text: '$totalCount',
              style: const TextStyle(color: AppColors.indicatorColor, fontSize: 18),
            ),
            if (selectedStatus == VoucherStatus.active) ...[
              const TextSpan(
                text: ' ，有 ',
                style: TextStyle(color: AppColors.secondaryTextColor),
              ),
              TextSpan(
                text: '$expiringSoonCount',
                style: const TextStyle(color: AppColors.formFieldErrorBorder, fontSize: 18),
              ),
              const TextSpan(
                text: ' 即將到期。',
                style: TextStyle(color: AppColors.secondaryTextColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build three month notice footer
  Widget _buildThreeMonthNotice() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          '僅顯示 近三個月 資料',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryValueColor,
          ),
        ),
      ),
    );
  }

  /// 建立空狀態 UI
  Widget _buildEmptyState(VoucherStatus status) {
    String message;
    switch (status) {
      case VoucherStatus.active:
        message = '尚無可使用優惠券，\n快到公益商家頁面兌換優惠吧！';
        break;
      case VoucherStatus.used:
        message = '尚無可使用優惠券，\n快到公益商家頁面兌換優惠吧！';
        break;
      case VoucherStatus.expired:
        message = '當優惠券過期後，\n將會顯示在這裡喔~';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ECOCOIcons.ticketFolder,
            size: 138,
            color: AppColors.dividerColor,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryValueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sticky filter tabs delegate (matching points_history_page style)
class _VoucherFilterTabsDelegate extends SliverPersistentHeaderDelegate {
  final VoucherStatus selectedStatus;
  final Function(VoucherStatus) onStatusChanged;

  _VoucherFilterTabsDelegate({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Row(
          children: [
            _buildTab(VoucherStatus.active, '可使用', context),
            _buildTab(VoucherStatus.used, '已使用', context),
            _buildTab(VoucherStatus.expired, '已過期', context),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(VoucherStatus status, String label, BuildContext context) {
    final isSelected = selectedStatus == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => onStatusChanged(status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: isSelected
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(1.0),
                      ),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(1.0),
                      ),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.secondaryValueColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_VoucherFilterTabsDelegate oldDelegate) {
    return oldDelegate.selectedStatus != selectedStatus;
  }
}
