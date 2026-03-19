import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/member_coupon_model.dart';
import '../models/member_coupon_with_rule.dart';
import '../models/voucher_model.dart'; // Keep VoucherStatus enum
import 'member_coupon_provider.dart';
import 'coupon_rules_provider.dart';

part 'voucher_wallet_provider.g.dart';

/// 票券夾選中的狀態篩選
@riverpod
class SelectedVoucherStatus extends _$SelectedVoucherStatus {
  @override
  VoucherStatus build() => VoucherStatus.active;

  void setStatus(VoucherStatus status) {
    state = status;
  }
}

/// Active coupons with CouponRule data
@Riverpod(keepAlive: true)
Stream<List<MemberCouponWithRule>> activeCouponsWithRules(Ref ref) async* {
  final repository = ref.watch(memberCouponRepositoryProvider);
  final stream = repository.watchActiveCoupons();

  await for (final coupons in stream) {
    final now = DateTime.now();

    // Filter: ACTIVE, UNAVAILABLE, HOLDING only
    final validCoupons = coupons.where((c) {
      final isStatusActive = c.currentStatus == MemberCouponStatus.active ||
          c.currentStatus == MemberCouponStatus.unavailable ||
          c.currentStatus == MemberCouponStatus.holding;

      if (!isStatusActive) return false;

      if (c.expiredAt != null) {
        final expiredDate = DateTime.tryParse(c.expiredAt!);
        if (expiredDate != null && expiredDate.isBefore(now)) {
          return false;
        }
      }

      return true;
    }).toList();

    final withRules = await _attachCouponRules(ref, validCoupons);
    yield withRules;
  }
}

/// Used coupons with CouponRule data
@Riverpod(keepAlive: true)
Stream<List<MemberCouponWithRule>> usedCouponsWithRules(Ref ref) async* {
  final repository = ref.watch(memberCouponRepositoryProvider);
  final stream = repository.watchHistoryCoupons();

  await for (final coupons in stream) {
    final validCoupons = coupons
        .where((c) => c.currentStatus == MemberCouponStatus.used)
        .toList();

    final withRules = await _attachCouponRules(ref, validCoupons);
    yield withRules;
  }
}

/// Expired coupons with CouponRule data
@Riverpod(keepAlive: true)
Stream<List<MemberCouponWithRule>> expiredCouponsWithRules(Ref ref) async* {
  final repository = ref.watch(memberCouponRepositoryProvider);
  // Use single stream to prevent flickering from multiple source updates
  final stream = repository.watchCouponsForExpiredCheck();

  await for (final coupons in stream) {
    final now = DateTime.now();

    final validCoupons = coupons.where((c) {
      // 1. Originally expired
      if (c.currentStatus == MemberCouponStatus.expired) return true;

      // 2. Active but date expired
      // Stream already excludes USED/REVOKED/CANCELED, so we just check date
      if (c.expiredAt != null) {
        final expiredDate = DateTime.tryParse(c.expiredAt!);
        if (expiredDate != null && expiredDate.isBefore(now)) {
          return true;
        }
      }

      return false;
    }).toList();

    final withRules = await _attachCouponRules(ref, validCoupons);
    yield withRules;
  }
}

/// Expiring soon count for active tab (7 days window)
@riverpod
int expiringSoonCount(Ref ref) {
  final activeAsync = ref.watch(activeCouponsWithRulesProvider);

  return activeAsync.when(
    data: (coupons) => coupons.where((c) => c.isExpiringSoon).length,
    loading: () => 0,
    error: (_, _) => 0,
  );
}

/// Helper: Attach CouponRule to each MemberCouponModel
Future<List<MemberCouponWithRule>> _attachCouponRules(
  Ref ref,
  List<MemberCouponModel> coupons,
) async {
  final results = <MemberCouponWithRule>[];

  for (final coupon in coupons) {
    // 檢查 ref 是否仍然有效
    if (!ref.mounted) break;

    final rule = await ref.read(
      couponRuleByIdProvider(coupon.couponRuleId).future,
    );
    results.add(MemberCouponWithRule(
      memberCoupon: coupon,
      couponRule: rule,
    ));
  }

  return results;
}
