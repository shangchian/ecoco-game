import 'member_coupon_model.dart';
import 'coupon_rule.dart';

/// Wrapper class combining MemberCouponModel with its associated CouponRule
/// for UI display purposes
class MemberCouponWithRule {
  final MemberCouponModel memberCoupon;
  final CouponRule? couponRule; // Nullable for missing/unsynced data

  const MemberCouponWithRule({
    required this.memberCoupon,
    this.couponRule,
  });

  // UI display helpers
  String get displayTitle => couponRule?.title ?? '[優惠券載入失敗]';
  String get merchantName => couponRule?.brandName ?? '';
  String? get cardImageUrl => couponRule?.cardImageUrl;

  // Status mapping for tab filtering
  bool get isActiveStatus => [
        MemberCouponStatus.active,
        MemberCouponStatus.unavailable,
        MemberCouponStatus.holding,
      ].contains(memberCoupon.currentStatus);

  bool get isUsedStatus =>
      memberCoupon.currentStatus == MemberCouponStatus.used;

  bool get isExpiredStatus =>
      memberCoupon.currentStatus == MemberCouponStatus.expired;

  // Should be displayed (exclude CANCELED/REVOKED)
  bool get shouldDisplay => ![
        MemberCouponStatus.canceled,
        MemberCouponStatus.revoked,
      ].contains(memberCoupon.currentStatus);

  // Check if expiring within 7 days
  bool get isExpiringSoon {
    if (memberCoupon.expiredAt == null) return false;
    final expiry = DateTime.parse(memberCoupon.expiredAt!);
    final now = DateTime.now();
    final daysUntilExpiry = expiry.difference(now).inDays;
    return daysUntilExpiry >= 0 && daysUntilExpiry <= 7;
  }
}
