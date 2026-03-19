import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '/database/app_database.dart';
import '/models/coupon_rule.dart';
import '/services/interface/i_coupon_rules_service.dart';
import '/services/online/coupon_rules_service.dart';

class CouponRulesRepository {
  final AppDatabase _db;
  final ICouponRulesService _couponRulesService;

  static const String _couponRulesEtagKey = 'coupon_rules_etag';
  static const String _couponRulesLastModifiedKey = 'coupon_rules_last_modified';
  // static const Duration _cacheValidityDuration = Duration(hours: 1);

  CouponRulesRepository({
    required AppDatabase db,
    ICouponRulesService? couponRulesService,
  })  : _db = db,
        _couponRulesService = couponRulesService ?? CouponRulesService();

  // ========== Reactive Streams ==========

  /// Watch all active coupon rules (sorted by sortOrder)
  Stream<List<CouponRule>> watchAllCouponRules() {
    return _db.watchAllCouponRules();
  }

  /// Watch only active and in-period coupon rules
  Stream<List<CouponRule>> watchActiveCouponRules() {
    return _db.watchActiveCouponRules();
  }

  /// Watch coupon rules by category
  Stream<List<CouponRule>> watchCouponRulesByCategory(String categoryCode) {
    return _db.watchCouponRulesByCategory(categoryCode);
  }

  /// Watch coupon rules by brand
  Stream<List<CouponRule>> watchCouponRulesByBrand(String brandId) {
    return _db.watchCouponRulesByBrand(brandId);
  }

  // ========== Snapshot Queries ==========

  /// Get a single coupon rule by ID
  Future<CouponRule?> getCouponRuleById(String id) async {
    return _db.getCouponRuleById(id);
  }

  /// Get all active coupon rules (snapshot)
  Future<List<CouponRule>> getActiveCouponRules() async {
    return _db.getActiveCouponRules();
  }

  // ========== Synchronization ==========

  /// Sync coupon rules from S3 (upsert + conditional request)
  Future<void> syncCouponRules({bool forceRefresh = false}) async {
    try {
      /*final cachedAt = await _db.getLatestCouponRuleCachedAt();

      if (!forceRefresh && cachedAt != null && _isCacheValid(cachedAt)) {
        log('Coupon rules cache is valid, skipping sync');
        return;
      }*/

      final prefs = await SharedPreferences.getInstance();
      final etag = prefs.getString(_couponRulesEtagKey);
      final lastModified = prefs.getString(_couponRulesLastModifiedKey);

      try {
        final response = await _couponRulesService.fetchCouponRules(
          etag: forceRefresh? null: etag,
          lastModified: forceRefresh? null: lastModified,
        );

        log('Fetched ${response.couponRules.length} coupon rules from S3');

        await _db.upsertCouponRules(response.couponRules);

        if (response.etag != null) {
          await prefs.setString(_couponRulesEtagKey, response.etag!);
        }
        if (response.lastModified != null) {
          await prefs.setString(_couponRulesLastModifiedKey, response.lastModified!);
        }

        log('Synced ${response.couponRules.length} coupon rules successfully');
      } on CacheNotModifiedException {
        log('Coupon rules not modified (304), using existing database data');
      }
    } catch (e) {
      log('Error syncing coupon rules: $e');

      // Fallback: Load bundled assets if database is empty
      final existingRules = await _db.watchAllCouponRules().first;
      if (existingRules.isEmpty) {
        log('Database empty, loading bundled coupon rules');
        try {
          final bundledCouponRules = await _couponRulesService.loadBundledCouponRules();
          await _db.upsertCouponRules(bundledCouponRules);
          log('Loaded ${bundledCouponRules.length} bundled coupon rules into database');
        } catch (e2) {
          log('Failed to load bundled coupon rules: $e2');
        }
      }
    }
  }

  // ========== Utility Methods ==========

  /// Check if cache is still valid
  // bool _isCacheValid(DateTime cachedAt) {
  //   final age = DateTime.now().difference(cachedAt);
  //   return age < _cacheValidityDuration;
  // }

  /// Clear all cache data (Deep Clean)
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_couponRulesEtagKey);
      await prefs.remove(_couponRulesLastModifiedKey);
      
      // Deep Clean
      await _db.clearAllCouponRules();
      
      log('[CouponRulesRepository] Cleared coupon rules cache (Deep Clean)');
    } catch (e) {
      log('Error clearing coupon rules cache: $e');
    }
  }

  // ========== Coupon Status Sync ==========

  /// Sync coupon status from API (with cleanup of orphaned records)
  Future<void> syncCouponStatuses() async {
    try {
      log('Fetching coupon status list from API');

      final response = await _couponRulesService.getCouponStatusList();

      log('Fetched ${response.couponStatusList.length} coupon statuses from API');

      // Upsert new/updated statuses
      await _db.upsertCouponRuleStatuses(response.couponStatusList);

      // Delete orphaned statuses (not in API response)
      final validIds = response.couponStatusList.map((e) => e.couponRuleId).toList();
      await _db.deleteOrphanedCouponStatuses(validIds);

      log('Synced ${response.couponStatusList.length} coupon statuses successfully');
    } catch (e) {
      log('Error syncing coupon statuses: $e');
      // Don't throw - allow graceful degradation
      // If status sync fails, UI will show only previously synced coupons
    }
  }

  // ========== Reactive Streams with Status ==========

  /// Watch active coupon rules WITH status (only those with status records)
  Stream<List<CouponRule>> watchActiveCouponRulesWithStatus() {
    return _db.watchActiveCouponRulesWithStatus();
  }

  /// Clear cache (Deep Clean)
  Future<void> clearCache() async {
    await clearAllCache();
  }
}
