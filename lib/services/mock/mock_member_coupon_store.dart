import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '/models/member_coupon_model.dart';
import '/models/coupon_rule.dart';
import '/models/redemption_credential_model.dart';

/// In-memory store for mock member coupons.
/// Maintains state during the app session for realistic coupon lifecycle simulation.
class MockMemberCouponStore {
  static final MockMemberCouponStore _instance = MockMemberCouponStore._();
  factory MockMemberCouponStore() => _instance;
  MockMemberCouponStore._();

  final Map<String, MemberCouponModel> _coupons = {};
  List<CouponRule>? _couponRules;
  bool _initialized = false;

  /// Initialize store with some pre-existing coupons
  Future<void> initialize() async {
    if (_initialized) return;

    // Load coupon rules to reference
    final jsonString =
        await rootBundle.loadString('assets/data/coupon-rules.json');
    final dynamic json = jsonDecode(jsonString);
    List<dynamic> rulesList;
    if (json is List) {
      rulesList = json;
    } else if (json is Map && json.containsKey('result')) {
      rulesList = json['result'];
    } else {
      throw Exception('Unexpected format in coupon-rules.json');
    }
    _couponRules = rulesList.map((item) => CouponRule.fromJson(item)).toList();

    // Generate some initial mock coupons (3 active coupons from different rules)
    final activeRules = _couponRules!.where((r) => r.isActive).take(5).toList();
    final now = DateTime.now();

    for (int i = 0; i < activeRules.length && i < 3; i++) {
      final rule = activeRules[i];
      final couponId = 'mock_coupon_initial_$i';

      _coupons[couponId] = MemberCouponModel(
        memberCouponId: couponId,
        couponRuleId: rule.id,
        currentStatus: MemberCouponStatus.active,
        syncAction: SyncAction.upsert,
        issuedAt: now.subtract(Duration(days: i + 1)).toIso8601String(),
        useStartAt: now.subtract(Duration(days: i + 1)).toIso8601String(),
        expiredAt: now.add(Duration(days: 30 - i)).toIso8601String(),
        lastUpdatedAt: now.toIso8601String(),
        redemptionCredentials: _generateCredentials(rule),
        exchangeUnits: _getMockExchangeUnits(rule),
      );
    }

    // Add 1 history coupon (used)
    if (activeRules.length > 3) {
      final usedRule = activeRules[3];
      final usedCouponId = 'mock_coupon_used_0';
      _coupons[usedCouponId] = MemberCouponModel(
        memberCouponId: usedCouponId,
        couponRuleId: usedRule.id,
        currentStatus: MemberCouponStatus.used,
        syncAction: SyncAction.upsert,
        issuedAt: now.subtract(const Duration(days: 10)).toIso8601String(),
        useStartAt: now.subtract(const Duration(days: 10)).toIso8601String(),
        usedAt: now.subtract(const Duration(days: 5)).toIso8601String(),
        lastUpdatedAt: now.subtract(const Duration(days: 5)).toIso8601String(),
        redemptionCredentials: [],
        exchangeUnits: _getMockExchangeUnits(usedRule),
      );
    }

    _initialized = true;
  }

  /// Generate mock redemption credentials
  /// Mock 模式下永遠生成 BARCODE 和 QR_CODE 以便測試
  List<RedemptionCredentialModel> _generateCredentials(CouponRule rule) {
    final random = Random();
    final randomCode = List.generate(12, (_) => random.nextInt(10)).join();

    if (rule.assetRedeemType == AssetRedeemType.copyCode) {
      return [
        RedemptionCredentialModel(
          type: CredentialType.textCode,
          title: '優惠代碼',
          value: 'CODE$randomCode',
          showValue: true,
        ),
      ];
    }

    return [
      RedemptionCredentialModel(
        type: CredentialType.barcode,
        title: '請出示條碼結帳',
        value: '88$randomCode',
        showValue: true,
      ),
      RedemptionCredentialModel(
        type: CredentialType.qrCode,
        title: null,
        value: '88$randomCode',
        showValue: false,
      ),
    ];
  }

  /// Generate mock exchange units based on rule type
  int _getMockExchangeUnits(CouponRule rule) {
    if (rule.exchangeInputType == ExchangeInputType.amountDiscount) {
      // Return a random amount like 100, 200, 500
      return [100, 200, 500, 1000][Random().nextInt(4)];
    } else if (rule.exchangeInputType == ExchangeInputType.pointsConversion) {
      // Return a random point amount like 50, 100, 300
      return [50, 100, 300, 888][Random().nextInt(4)];
    }
    // Default quantity is 1
    return 1;
  }

  /// Get all coupons, optionally filtered by updatedSince
  /// Returns coupons updated after the given timestamp
  ///
  /// Note: For incremental sync, the API contract is to return items updated AFTER
  /// the given timestamp. We add 1 second buffer when creating new coupons to ensure
  /// they are always picked up by sync.
  List<MemberCouponModel> getCoupons({String? updatedSince}) {
    var coupons = _coupons.values.toList();

    if (updatedSince != null) {
      final since = DateTime.parse(updatedSince);
      coupons = coupons.where((c) {
        final lastUpdated = DateTime.parse(c.lastUpdatedAt);
        return lastUpdated.isAfter(since);
      }).toList();
    }

    return coupons;
  }

  /// Get a specific coupon by ID
  MemberCouponModel? getCouponById(String memberCouponId) {
    return _coupons[memberCouponId];
  }

  /// Sync an external coupon into the store
  /// Used when a coupon exists in the database but not in the mock store
  void syncCoupon(MemberCouponModel coupon) {
    _coupons[coupon.memberCouponId] = coupon;
  }

  /// Issue a new coupon (ACTIVE status)
  ///
  /// The lastUpdatedAt is set to now + 1 second to ensure incremental sync
  /// picks up this coupon even when syncing immediately after creation.
  MemberCouponModel issueCoupon({
    required String couponRuleId,
    required MemberCouponStatus initialStatus,
  }) {
    final rule = _couponRules?.firstWhere(
      (r) => r.id == couponRuleId,
      orElse: () => throw Exception('Coupon rule not found: $couponRuleId'),
    );

    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final couponId = 'mock_coupon_$timestamp';
    // Add 1 second buffer to ensure this coupon is picked up by incremental sync
    final lastUpdatedAt = now.add(const Duration(seconds: 1));

    final coupon = MemberCouponModel(
      memberCouponId: couponId,
      couponRuleId: couponRuleId,
      currentStatus: initialStatus,
      syncAction: SyncAction.upsert,
      issuedAt: now.toIso8601String(),
      useStartAt: now.toIso8601String(),
      expiredAt: now.add(const Duration(days: 30)).toIso8601String(),
      usedAt: initialStatus == MemberCouponStatus.used
          ? now.toIso8601String()
          : null,
      lastUpdatedAt: lastUpdatedAt.toIso8601String(),
      redemptionCredentials: _generateCredentials(rule!),
      exchangeUnits: _getMockExchangeUnits(rule),
    );

    _coupons[couponId] = coupon;
    return coupon;
  }

  /// Prepare coupon (create HOLDING status, 5-minute validity)
  ///
  /// The lastUpdatedAt is set to now + 1 second to ensure incremental sync
  /// picks up this coupon even when syncing immediately after creation.
  MemberCouponModel prepareCoupon({required String couponRuleId}) {
    final rule = _couponRules?.firstWhere(
      (r) => r.id == couponRuleId,
      orElse: () => throw Exception('Coupon rule not found: $couponRuleId'),
    );

    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final couponId = 'mock_holding_$timestamp';
    // Add 1 second buffer to ensure this coupon is picked up by incremental sync
    final lastUpdatedAt = now.add(const Duration(seconds: 1));

    final coupon = MemberCouponModel(
      memberCouponId: couponId,
      couponRuleId: couponRuleId,
      currentStatus: MemberCouponStatus.holding,
      syncAction: SyncAction.upsert,
      issuedAt: now.toIso8601String(),
      useStartAt: now.toIso8601String(),
      expiredAt: now.add(const Duration(minutes: 5)).toIso8601String(),
      lastUpdatedAt: lastUpdatedAt.toIso8601String(),
      redemptionCredentials: _generateCredentials(rule!),
      exchangeUnits: _getMockExchangeUnits(rule),
    );

    _coupons[couponId] = coupon;
    return coupon;
  }

  /// Finalize coupon (change HOLDING to USED)
  MemberCouponModel finalizeCoupon({required String memberCouponId}) {
    final existing = _coupons[memberCouponId];
    if (existing == null) {
      throw Exception('Coupon not found: $memberCouponId');
    }

    final now = DateTime.now();
    final updated = MemberCouponModel(
      memberCouponId: existing.memberCouponId,
      couponRuleId: existing.couponRuleId,
      currentStatus: MemberCouponStatus.used,
      syncAction: SyncAction.upsert,
      issuedAt: existing.issuedAt,
      useStartAt: existing.useStartAt,
      expiredAt: existing.expiredAt,
      usedAt: now.toIso8601String(),
      lastUpdatedAt: now.toIso8601String(),
      redemptionCredentials: existing.redemptionCredentials,
      exchangeUnits: existing.exchangeUnits,
    );

    _coupons[memberCouponId] = updated;
    return updated;
  }

  /// Cancel coupon (change HOLDING to CANCELED)
  MemberCouponModel cancelCoupon({required String memberCouponId}) {
    final existing = _coupons[memberCouponId];
    if (existing == null) {
      throw Exception('Coupon not found: $memberCouponId');
    }

    if (existing.currentStatus != MemberCouponStatus.holding) {
      throw Exception('Only HOLDING coupons can be canceled');
    }

    final now = DateTime.now();
    final updated = MemberCouponModel(
      memberCouponId: existing.memberCouponId,
      couponRuleId: existing.couponRuleId,
      currentStatus: MemberCouponStatus.canceled,
      syncAction: SyncAction.delete, // CANCELED triggers DELETE sync
      issuedAt: existing.issuedAt,
      useStartAt: existing.useStartAt,
      expiredAt: existing.expiredAt,
      canceledAt: now.toIso8601String(),
      lastUpdatedAt: now.toIso8601String(),
      redemptionCredentials: [],
      exchangeUnits: existing.exchangeUnits,
    );

    _coupons[memberCouponId] = updated;
    return updated;
  }

  /// Get current status of a coupon
  MemberCouponStatus? getCouponStatus({required String memberCouponId}) {
    return _coupons[memberCouponId]?.currentStatus;
  }

  /// Check if coupon status is finalized (USED, CANCELED, EXPIRED, REVOKED)
  bool isCouponFinalized({required String memberCouponId}) {
    final status = _coupons[memberCouponId]?.currentStatus;
    if (status == null) return false;
    return status == MemberCouponStatus.used ||
        status == MemberCouponStatus.canceled ||
        status == MemberCouponStatus.expired ||
        status == MemberCouponStatus.revoked;
  }

  /// Get finalized timestamp for a coupon
  String? getFinalizedAt({required String memberCouponId}) {
    final coupon = _coupons[memberCouponId];
    if (coupon == null) return null;

    switch (coupon.currentStatus) {
      case MemberCouponStatus.used:
        return coupon.usedAt;
      case MemberCouponStatus.canceled:
        return coupon.canceledAt;
      case MemberCouponStatus.expired:
        return coupon.expiredAt;
      case MemberCouponStatus.revoked:
        return coupon.revokedAt;
      default:
        return null;
    }
  }

  /// Clear all coupons (for logout)
  void clear() {
    _coupons.clear();
    _initialized = false;
  }
}
