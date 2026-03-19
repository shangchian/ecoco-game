import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '/models/coupon_rule.dart';
import '/widgets/ecoco_points_badge.dart';

/// 現場型票券資訊頁（僅顯示說明，無操作）
@RoutePage()
class MerchantRewardTicketInfoPage extends ConsumerWidget {
  final CouponRule couponRule;
  final int userPoints;

  const MerchantRewardTicketInfoPage({
    super.key,
    required this.couponRule,
    this.userPoints = 0,
  });

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildMerchantCard(context),
          const SizedBox(height: 6),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildContentArea(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundYellow,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 56,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.router.maybePop(),
      ),
      title: const Text(
        '優惠券',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
      actions: [
        EcocoPointsBadge.detailed(points: userPoints),
      ],
    );
  }

  Widget _buildMerchantCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                couponRule.cardImageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.store,
                    size: 32,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  couponRule.brandName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '兌換期限：$_today',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    const usageDescription = '1. 無環保杯：使用ECOCO點數折抵5元，每杯折抵上限5元。\n'
        '2. 有環保杯：使用ECOCO點數折抵5元 + 環保杯5元 = 10元。\n'
        '3. 迷點會員折抵5元。\n'
        '4. 迷點會員折抵5元+環保杯5元=10元。\n'
        '以上優惠折扣不得同時使用，ECOCO和迷點會員折扣需擇一使用，使用ECOCO點數最多折抵5元。';

    const notice =
        '本折價券不適用於以下產品：\n• 綠光鮮奶系列 (家庭號、小資生活瓶)\n• 小迷豆漿\n且不得與其他優惠合併使用，亦不得找零或兌換現金。不適用門市：百貨櫃位、大型商場中的櫃位或者特殊的Plus店等。\n另有部分門市無加入兌換方案，請依現場店家公告為準。';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('兌換說明'),
            const SizedBox(height: 12),
            Text(
              usageDescription,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('注意事項'),
            const SizedBox(height: 12),
            Text(
              notice,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 100), // 底部留白，避免內容被按鈕遮住
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBottomButton() {
    final usedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.3),
              Colors.white.withValues(alpha: 1.0),
            ],
          ),
        ),
        child: SizedBox(
          height: 38,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: AppColors.disabledButtomBackground,
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              '已於$usedDate使用',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
