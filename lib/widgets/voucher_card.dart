import 'package:ecoco_app/ecoco_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/member_coupon_with_rule.dart';
import '../models/member_coupon_model.dart';

/// 票券卡片元件
class VoucherCard extends StatelessWidget {
  final MemberCouponWithRule memberCouponWithRule;
  final VoidCallback onTap;
  final bool showUnseenBadge;

  const VoucherCard({
    super.key,
    required this.memberCouponWithRule,
    required this.onTap,
    this.showUnseenBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final memberCoupon = memberCouponWithRule.memberCoupon;
    final couponRule = memberCouponWithRule.couponRule;

    final isActuallyExpired = _checkIsExpired(memberCoupon);

    // 判斷是否需要顯示半透明覆蓋層（已使用或已過期的票券）
    final bool shouldShowOverlay =
        memberCoupon.currentStatus == MemberCouponStatus.expired ||
        isActuallyExpired;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // 商家 Logo
                _buildLogo(couponRule?.cardImageUrl, showUnseenBadge),
                const SizedBox(width: 12),
                // 票券資訊
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 票券名稱
                      Text(
                        memberCouponWithRule.displayTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // 日期資訊
                      Text(
                        _getDateText(memberCoupon, isActuallyExpired),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Check if 查看按鈕 should be shown - hide if actually expired
                if (_shouldShowButton(
                  memberCoupon.currentStatus,
                  isActuallyExpired,
                ))
                  IgnorePointer(
                    child: OutlinedButton(
                      onPressed: () {}, // 視覺用途，點擊事件由外層 GestureDetector 處理
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.indicatorColor,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        minimumSize: const Size(30, 18),
                      ),
                      child: const Text(
                        '查看',
                        style: TextStyle(
                          color: AppColors.indicatorColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // 白色半透明覆蓋層（已使用或已過期的票券）
            if (shouldShowOverlay)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build logo with network image support and optional unseen badge
  Widget _buildLogo(String? imageUrl, bool showBadge) {
    Widget logoWidget;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      logoWidget = Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.thirdValueColor, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Image.network(
            imageUrl,
            width: 78,
            height: 78,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildDefaultLogo();
            },
          ),
        ),
      );
    } else {
      logoWidget = _buildDefaultLogo();
    }

    // 如果需要顯示未看過標記
    if (showBadge) {
      return SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            logoWidget,
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.formFieldErrorBorder,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return logoWidget;
  }

  /// Build default logo placeholder
  Widget _buildDefaultLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.thirdValueColor, width: 1),
      ),
      child: const Center(
        child: Icon(
          ECOCOIcons.ticketFolder,
          color: Color(0xffb2b2b2),
          size: 30,
        ),
      ),
    );
  }

  /// Determine if button should be shown
  bool _shouldShowButton(MemberCouponStatus status, bool isActuallyExpired) {
    if (isActuallyExpired) return false;

    return status == MemberCouponStatus.active ||
        status == MemberCouponStatus.used ||
        status == MemberCouponStatus.holding ||
        status == MemberCouponStatus.unavailable;
  }

  /// Check if coupon is expired based on date (regardless of status)
  bool _checkIsExpired(MemberCouponModel memberCoupon) {
    if (memberCoupon.currentStatus == MemberCouponStatus.expired) return true;

    // Check strict final states where date doesn't matter for "Active Expiry" logic
    if (memberCoupon.currentStatus == MemberCouponStatus.used ||
        memberCoupon.currentStatus == MemberCouponStatus.revoked ||
        memberCoupon.currentStatus == MemberCouponStatus.canceled) {
      return false;
    }

    if (memberCoupon.expiredAt != null) {
      final expireDate = DateTime.tryParse(memberCoupon.expiredAt!);
      if (expireDate != null) {
        final now = DateTime.now();
        // Check if expiredAt is strictly before now
        return expireDate.isBefore(now);
      }
    }
    return false;
  }

  /// 根據票券狀態顯示對應的日期文字
  String _getDateText(MemberCouponModel memberCoupon, bool isActuallyExpired) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // 優先處理過期情況 (不管是狀態過期還是時間過期)
    if (isActuallyExpired) {
      final issuedDate = DateTime.parse(memberCoupon.issuedAt);
      if (memberCoupon.expiredAt != null) {
        final expireDate = DateTime.parse(memberCoupon.expiredAt!);
        return '${dateFormat.format(issuedDate)} ~ ${dateFormat.format(expireDate)}';
      }
      return '已過期';
    }

    switch (memberCoupon.currentStatus) {
      case MemberCouponStatus.active:
      case MemberCouponStatus.holding:
        // 可使用：顯示有效期限
        if (memberCoupon.expiredAt != null) {
          final expireDate = DateTime.parse(memberCoupon.expiredAt!);
          return '使用期限：${dateFormat.format(expireDate)}';
        } else {
          return '無使用期限';
        }

      case MemberCouponStatus.unavailable:
        final startDate = DateTime.parse(memberCoupon.useStartAt);
        return '${dateFormat.format(startDate)} 起生效';

      case MemberCouponStatus.used:
        // 已使用：顯示使用日期
        if (memberCoupon.usedAt != null) {
          final usedDate = DateTime.parse(memberCoupon.usedAt!);
          return '${dateFormat.format(usedDate)} 已使用';
        }
        return '已使用';

      // EXPIRED checked at top of function
      case MemberCouponStatus.expired:
        return '已過期';

      default:
        return '';
    }
  }
}
