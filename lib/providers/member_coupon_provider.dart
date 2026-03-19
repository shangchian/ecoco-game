import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/member_coupon_repository.dart';
import '../models/member_coupon_model.dart';
import '../models/member_coupon_with_rule.dart';
import '../models/cancel_coupon_response.dart';
import '../models/finalize_coupon_response.dart';
import '../models/issue_coupon_response.dart';
import '../models/member_coupon_status_response.dart';
import '../models/prepare_coupon_response.dart';
import '../flavors.dart';
import '../services/mock/members_service_mock.dart';
import 'app_database_provider.dart';
import 'members_service_provider.dart';
import 'auth_provider.dart';
import 'coupon_rules_provider.dart';

part 'member_coupon_provider.g.dart';

@Riverpod(keepAlive: true)
MemberCouponRepository memberCouponRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final membersService = ref.watch(membersServiceProvider);
  return MemberCouponRepository(db: db, membersService: membersService);
}

@riverpod
Stream<List<MemberCouponModel>> activeMemberCoupons(Ref ref) {
  return ref.watch(memberCouponRepositoryProvider).watchActiveCoupons();
}

@riverpod
Stream<List<MemberCouponModel>> historyMemberCoupons(Ref ref) {
  return ref.watch(memberCouponRepositoryProvider).watchHistoryCoupons();
}

/// Issue a coupon with automatic token management
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
/// [branchCode] - Optional branch verification code entered by staff
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 400 for invalid branchCode)
@riverpod
Future<IssueCouponResponse> issueCoupon(
  Ref ref, {
  required String couponRuleId,
  required int exchangeUnits,
  String? branchCode,
}) async {
  final repository = ref.read(memberCouponRepositoryProvider);

  return repository.issueCoupon(
    couponRuleId: couponRuleId,
    exchangeUnits: exchangeUnits,
    branchCode: branchCode,
  );
}

/// Sync member coupons from server to local database
@riverpod
Future<void> syncMemberCouponsAction(Ref ref) async {
  final repository = ref.read(memberCouponRepositoryProvider);
  await repository.syncMemberCoupons();
}

/// Get member coupons with rules by IDs (for display after issue)
/// Note: keepAlive is required to prevent disposal during async operations
@Riverpod(keepAlive: true)
Future<List<MemberCouponWithRule>> memberCouponsWithRulesById(
  Ref ref,
  List<String> ids,
) async {
  log('[DEBUG] memberCouponsWithRulesById called with ids: $ids');

  List<MemberCouponModel> coupons;

  // Mock Mode: 直接從 MockMemberCouponStore 取得，繞過資料庫
  if (F.useMockService) {
    final membersService = ref.read(membersServiceProvider) as MembersServiceMock;
    coupons = ids
        .map((id) => membersService.getMemberCouponById(id))
        .whereType<MemberCouponModel>()
        .toList();
  } else {
    final repository = ref.read(memberCouponRepositoryProvider);
    log('[DEBUG] Repository instance: ${identityHashCode(repository)}');
    coupons = await repository.getMemberCouponsByIds(ids);
    log('[DEBUG] Got ${coupons.length} coupons from repository');
  }

  final results = <MemberCouponWithRule>[];
  for (final coupon in coupons) {
    final rule = await ref.read(
      couponRuleByIdProvider(coupon.couponRuleId).future,
    );
    results.add(MemberCouponWithRule(memberCoupon: coupon, couponRule: rule));
  }
  return results;
}

/// Prepare a coupon for POS redemption (creates HOLDING status coupon)
///
/// [couponRuleId] - The coupon rule UID to exchange
/// [exchangeUnits] - Number of units to exchange (must be >= 1)
///
/// Returns prepared coupon information including memberCouponId
/// The HOLDING status coupon has a 5-minute validity period
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30006 for insufficient points)
@riverpod
Future<PrepareCouponResponse> prepareCoupon(
  Ref ref, {
  required String couponRuleId,
  required int exchangeUnits,
}) async {
  final repository = ref.read(memberCouponRepositoryProvider);

  return repository.prepareCoupon(
    couponRuleId: couponRuleId,
    exchangeUnits: exchangeUnits,
  );
}

/// Cancel a HOLDING status coupon
///
/// [memberCouponId] - The member coupon UID to cancel
///
/// Returns cancel confirmation including refunded points
/// Only HOLDING status coupons can be canceled
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 30017 for already canceled)
@riverpod
Future<CancelCouponResponse> cancelCoupon(
  Ref ref, {
  required String memberCouponId,
}) async {
  final repository = ref.read(memberCouponRepositoryProvider);

  return repository.cancelCoupon(
    memberCouponId: memberCouponId,
  );
}

/// Get current status of a member coupon for polling
///
/// [memberCouponId] - The member coupon UID to check
///
/// Returns current status information for POS flow status confirmation
/// Used for polling during POS redemption to detect silent notification updates
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors (e.g., code 10010 for coupon not found)
@riverpod
Future<MemberCouponStatusResponse> getMemberCouponStatus(
  Ref ref, {
  required String memberCouponId,
}) async {
  /* final token = await ref.read(authProvider.notifier).getValidAccessToken(); */
  final membersService = ref.read(membersServiceProvider);

  return membersService.getMemberCouponStatus(
    memberCouponId: memberCouponId,
  );
}

/// Finalize coupon usage (mark as USED)
///
/// [memberCouponId] - The member coupon UID to finalize
///
/// Returns finalize confirmation with updated status
/// Used for verification code flow where staff confirms usage
///
/// Throws:
/// - [NotAuthenticatedException] if user is not logged in
/// - [TokenRefreshFailedException] if token refresh fails
/// - [ApiException] for API errors
@riverpod
Future<FinalizeCouponResponse> finalizeCoupon(
  Ref ref, {
  required String memberCouponId,
}) async {
  /* final token = await ref.read(authProvider.notifier).getValidAccessToken(); */
  final repository = ref.read(memberCouponRepositoryProvider);

  return repository.finalizeCoupon(memberCouponId);
}

/// Update local coupon status (for POS polling)
@riverpod
Future<void> updateLocalCouponStatus(
  Ref ref, {
  required String memberCouponId,
  required String status,
  DateTime? usedAt,
}) async {
  final repository = ref.read(memberCouponRepositoryProvider);
  await repository.updateLocalCouponStatus(
    memberCouponId: memberCouponId,
    status: status,
    usedAt: usedAt,
  );
}
