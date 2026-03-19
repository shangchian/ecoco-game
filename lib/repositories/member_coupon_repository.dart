import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../models/member_coupon_model.dart';
import '../models/cancel_coupon_response.dart';
import '../models/finalize_coupon_response.dart';
import '../models/issue_coupon_response.dart';
import '../models/prepare_coupon_response.dart';
import '../services/interface/i_members_service.dart';
import '../services/online/members_service.dart';
import '../services/mock/members_service_mock.dart';
import '../flavors.dart';

class MemberCouponRepository {
  static const String _syncCursorKey = 'member_coupon_sync_cursor';

  final IMembersService _membersService;
  final AppDatabase _db;

  MemberCouponRepository({IMembersService? membersService, AppDatabase? db})
      : _membersService = membersService ??
            (F.useMockService ? MembersServiceMock() : MembersService()),
        _db = db ?? AppDatabase();

  /// Sync member coupons from server to local database
  Future<void> syncMemberCoupons() async {
    try {
      // 1. Get sync cursor from SharedPreferences (priority) or DB (fallback)
      final prefs = await SharedPreferences.getInstance();
      final storedCursor = prefs.getString(_syncCursorKey);

      String? updatedSince;
      if (storedCursor != null) {
        // Use SharedPreferences cursor (survives DB clear)
        updatedSince = storedCursor;
      } else {
        // Fallback to database (for migration from old behavior)
        final lastUpdated = await _db.getLatestMemberCouponUpdatedAt();
        updatedSince = lastUpdated?.toIso8601String();
      }

      int page = 1;
      const int limit = 100;
      bool hasMore = true;

      // Track max lastUpdatedAt from responses for cursor update
      DateTime? maxLastUpdatedAt;

      // 2. Fetch pages and update DB incrementally
      while (hasMore) {
        final coupons = await _membersService.getCoupons(
          updatedSince: updatedSince,
          page: page,
          limit: limit,
        );

        final List<MemberCouponModel> pageToUpsert = [];
        final List<String> pageToDelete = [];

        if (coupons.isEmpty) {
          hasMore = false;
        } else {
          for (final coupon in coupons) {
            if (coupon.syncAction == SyncAction.delete) {
              pageToDelete.add(coupon.memberCouponId);
            } else {
              pageToUpsert.add(coupon);
            }

            // Track max lastUpdatedAt for cursor update
            final couponUpdatedAt = DateTime.parse(coupon.lastUpdatedAt);
            if (maxLastUpdatedAt == null ||
                couponUpdatedAt.isAfter(maxLastUpdatedAt)) {
              maxLastUpdatedAt = couponUpdatedAt;
            }
          }

          // Apply changes to DB immediately for this page (Incremental Update)
          if (pageToDelete.isNotEmpty) {
            await _db.deleteMemberCoupons(pageToDelete);
          }
          if (pageToUpsert.isNotEmpty) {
            await _db.upsertMemberCoupons(pageToUpsert);
            log('[DEBUG] Page $page upserted: ${pageToUpsert.length} items');
          }

          log('[DEBUG] Synced Page $page: ${pageToUpsert.length} upserted, ${pageToDelete.length} deleted');

          if (coupons.length < limit) {
            hasMore = false;
          } else {
            page++;
          }
        }
      }

      // 4. Update sync cursor ONLY after successful completion
      if (maxLastUpdatedAt != null) {
        // Has data: use max lastUpdatedAt from response
        await prefs.setString(
            _syncCursorKey, maxLastUpdatedAt.toIso8601String());
      } else if (updatedSince == null) {
        // First sync with no data: store current time to avoid repeated full queries
        await prefs.setString(
            _syncCursorKey, DateTime.now().toUtc().toIso8601String());
      }
      // Otherwise (subsequent sync with no new data): keep existing cursor

      log('Synced member coupons check finished.');
    } catch (e) {
      log('Error syncing member coupons: $e');
      // Do NOT update cursor on failure - next sync will retry from last successful point
    }
  }

  /// Finalize coupon usage
  Future<FinalizeCouponResponse> finalizeCoupon(String memberCouponId) async {
    final idempotencyKey = const Uuid().v4();

    final response = await _membersService.finalizeCoupon(
      memberCouponId: memberCouponId,
      idempotencyKey: idempotencyKey,
    );

    // Update local DB
    await _db.updateMemberCouponStatus(
      response.memberCouponId,
      response.status.name.toUpperCase(),
      DateTime.parse(response.usedAt),
    );

    return response;
  }

  /// Watch active coupons
  Stream<List<MemberCouponModel>> watchActiveCoupons() {
    return _db.watchActiveMemberCoupons();
  }

  /// Watch history (used/expired) coupons
  Stream<List<MemberCouponModel>> watchHistoryCoupons() {
    return _db.watchHistoryMemberCoupons();
  }

  /// Watch coupons for expired check
  Stream<List<MemberCouponModel>> watchCouponsForExpiredCheck() {
    return _db.watchCouponsForExpiredCheck();
  }

  /// Issue a coupon (exchange points for coupon)
  ///
  /// [token] - Access token for authentication
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  /// [branchCode] - Optional branch verification code entered by staff
  Future<IssueCouponResponse> issueCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    String? branchCode,
  }) async {
    final idempotencyKey = const Uuid().v4();

    final response = await _membersService.issueCoupon(
      couponRuleId: couponRuleId,
      exchangeUnits: exchangeUnits,
      branchCode: branchCode,
      idempotencyKey: idempotencyKey,
    );

    // Mock Mode: 直接寫入資料庫，避免增量同步的時序問題
    if (F.useMockService) {
      final mockService = _membersService as MembersServiceMock;
      final coupons = <MemberCouponModel>[];
      for (final couponId in response.issuedMemberCouponIds) {
        final coupon = mockService.getMemberCouponById(couponId);
        if (coupon != null) {
          coupons.add(coupon);
        }
      }
      if (coupons.isNotEmpty) {
        await _db.upsertMemberCoupons(coupons);
      }
    }

    return response;
  }

  /// Get member coupons by IDs from local database
  Future<List<MemberCouponModel>> getMemberCouponsByIds(List<String> ids) async {
    return _db.getMemberCouponsByIds(ids);
  }

  /// Prepare a coupon for POS redemption (creates HOLDING status coupon)
  ///
  /// [token] - Access token for authentication
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  ///
  /// Returns prepared coupon information including memberCouponId
  /// The HOLDING status coupon has a 5-minute validity period
  ///
  /// In Mock Mode, the coupon is directly inserted into the database
  /// to avoid timing issues with incremental sync.
  Future<PrepareCouponResponse> prepareCoupon({
    required String couponRuleId,
    required int exchangeUnits,
  }) async {
    final idempotencyKey = const Uuid().v4();

    final response = await _membersService.prepareCoupon(
      couponRuleId: couponRuleId,
      exchangeUnits: exchangeUnits,
      idempotencyKey: idempotencyKey,
    );

    // Mock Mode: 直接寫入資料庫，避免增量同步的時序問題
    if (F.useMockService) {
      final mockService = _membersService as MembersServiceMock;
      final coupon = mockService.getMemberCouponById(response.memberCouponId);
      if (coupon != null) {
        await _db.upsertMemberCoupons([coupon]);
      }
    }

    return response;
  }

  /// Cancel a HOLDING status coupon
  ///
  /// [token] - Access token for authentication
  /// [memberCouponId] - The member coupon UID to cancel
  ///
  /// Returns cancel confirmation including refunded points
  /// Only HOLDING status coupons can be canceled
  Future<CancelCouponResponse> cancelCoupon({
    required String memberCouponId,
  }) async {
    final idempotencyKey = const Uuid().v4();

    final response = await _membersService.cancelCoupon(
      memberCouponId: memberCouponId,
      idempotencyKey: idempotencyKey,
    );

    // Remove from local database
    await _db.deleteMemberCoupons([memberCouponId]);

    return response;
  }

  /// Clear the sync cursor (call on logout)
  Future<void> clearSyncCursor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_syncCursorKey);
    log('Cleared member coupon sync cursor');
  }

  /// Clear all member coupons and sync cursor (for logout)
  Future<void> clearOnLogout() async {
    await _db.clearAllMemberCoupons();
    await clearSyncCursor();
    log('Cleared member coupons and sync cursor on logout');
  }

  /// Update local coupon status directly (used for POS polling updates)
  Future<void> updateLocalCouponStatus({
    required String memberCouponId,
    required String status,
    DateTime? usedAt,
  }) async {
    await _db.updateMemberCouponStatus(
      memberCouponId,
      status,
      usedAt,
    );
  }

  /// Reset repository state (clear all data and cursor)
  /// Used for app updates or deep clean
  Future<void> resetRepository() async {
    await clearOnLogout();
    log('[MemberCouponRepository] Repository reset completed');
  }
}
