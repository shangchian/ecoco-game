import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/providers/carousel_provider.dart';
import '/providers/coupon_rules_provider.dart';
import '/providers/member_coupon_provider.dart';
import '/providers/notifications_data_provider.dart';
import '/providers/site_repository_provider.dart';
import '/providers/brand_provider.dart';
import '/repositories/area_district_repository.dart';
import '/repositories/delete_reasons_repository.dart';
import '/services/initialization_service.dart';
import '/providers/wallet_provider.dart';
import '/models/auth_data_model.dart';

part 'version_manager.g.dart';

/// Service to handle app version checking and orchestrating cache cleanup on updates.
///
/// When the app is updated (version change detected), this service will:
/// 1. Log the update (From -> To)
/// 2. Clear caches for:
///    - Sites (ETags/LastMod)
///    - Carousels (ETags/LastMod)
///    - Coupon Rules (ETags/LastMod)
///    - Notifications (ETags/LastMod)
///    - Member Coupons (Clear DB & Cursor to force full resync)
/// 3. Update the stored version in SharedPreferences
///
/// This ensures users get fresh data after an update without forcing a logout.
class VersionManager {
  static const String _lastRunVersionKey = 'last_run_version';

  final Ref _ref;

  VersionManager(this._ref);

  /// Check version and perform cleanup if updated
  Future<void> checkVersionAndCleanup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      final currentFullVersion = '$version+$buildNumber';
      final lastVersion = prefs.getString(_lastRunVersionKey);

      // If it's a fresh install (lastVersion == null), just save current version
      if (lastVersion == null) {
        log('[VersionManager] First run detected. Saving version: $currentFullVersion');
        await prefs.setString(_lastRunVersionKey, currentFullVersion);
        return;
      }

      // If version matches, no action needed
      if (lastVersion == currentFullVersion) {
        log('[VersionManager] Version match ($currentFullVersion). No cleanup needed.');
        return;
      }

      // Version changed: Updated!
      log('[VersionManager] App updated from $lastVersion to $currentFullVersion. Initiating cleanup...');

      await _performCleanup();

      // Update stored version after successful cleanup
      await prefs.setString(_lastRunVersionKey, currentFullVersion);
      log('[VersionManager] Cleanup complete. Version updated to $currentFullVersion');

    } catch (e) {
      log('[VersionManager] Error during version check/cleanup: $e');
      // Non-fatal error, app can continue but might use stale data
    }
  }

  /// Execute cleanup for all relevant repositories
  Future<void> _performCleanup() async {
    log('[VersionManager] Starting Deep Clean cleanup...');

    // 1. Sites: Deep Clean (Backup Favorites -> Clear DB -> Restore Next Sync)
    try {
      final siteRepo = _ref.read(siteRepositoryProvider);
      await siteRepo.clearAllCache(); 
      log('[VersionManager] Sites cache cleared (Deep Clean)');
    } catch (e) {
      log('[VersionManager] Failed to clear Sites cache: $e');
    }

    // 2. Carousels: Deep Clean
    try {
      final carouselRepo = _ref.read(carouselRepositoryProvider);
      await carouselRepo.clearCache();
      log('[VersionManager] Carousels cache cleared (Deep Clean)');
    } catch (e) {
      log('[VersionManager] Failed to clear Carousels cache: $e');
    }

    // 3. Coupon Rules: Deep Clean
    try {
      final couponRulesRepo = _ref.read(couponRulesRepositoryProvider);
      await couponRulesRepo.clearCache();
      log('[VersionManager] Coupon Rules cache cleared (Deep Clean)');
    } catch (e) {
      log('[VersionManager] Failed to clear Coupon Rules cache: $e');
    }

    // 4. Notifications: Deep Clean (Backup Read Status -> Clear DB -> Restore Next Sync)
    try {
      final notificationRepo = _ref.read(notificationsDataRepositoryProvider);
      await notificationRepo.clearCache();
      log('[VersionManager] Notifications cache cleared (Deep Clean)');
    } catch (e) {
      log('[VersionManager] Failed to clear Notifications cache: $e');
    }

    // 5. Member Coupons: Full reset (DB + Cursor) to force re-fetch
    try {
      final memberCouponRepo = _ref.read(memberCouponRepositoryProvider);
      await memberCouponRepo.resetRepository();
      log('[VersionManager] Member Coupons reset (Deep Clean)');
    } catch (e) {
      log('[VersionManager] Failed to reset Member Coupons: $e');
    }

    // 6. Brands: Deep Clean
    try {
      final brandRepo = _ref.read(brandRepositoryProvider);
      await brandRepo.clearAllCache();
      log('[VersionManager] Brands cache cleared (Deep Clean)');
    } catch (e) {
      log('[VersionManager] Failed to clear Brands cache: $e');
    }

    // 7. Area/District: Clear cache (Memory/Prefs only usually)
    try {
      // AreaDistrictRepository is not a provider, instantiate directly
      final areaDistrictRepo = AreaDistrictRepository();
      await areaDistrictRepo.clearAreaDistrictCache();
      log('[VersionManager] Area/District cache cleared');
    } catch (e) {
      log('[VersionManager] Failed to clear Area/District cache: $e');
    }

    // 8. Delete Reasons: Clear cache
    try {
      final deleteReasonsRepo = DeleteReasonsRepository();
      await deleteReasonsRepo.clearDeleteReasonsCache();
      log('[VersionManager] Delete Reasons cache cleared');
    } catch (e) {
      log('[VersionManager] Failed to clear Delete Reasons cache: $e');
    }

    // 9. Wallet: Clear cache
    try {
      final walletNotifier = _ref.read(walletProvider.notifier);
      await walletNotifier.clear();
      log('[VersionManager] Wallet cache cleared');
    } catch (e) {
      log('[VersionManager] Failed to clear Wallet cache: $e');
    }
  }
}

/// Provider for VersionManager
@Riverpod(keepAlive: true)
VersionManager versionManager(Ref ref) {
  return VersionManager(ref);
}

/// Initialization Step for Version Check
class VersionCheckStep implements InitializationStep {
  @override
  String get name => '檢查版本更新';

  @override
  Future<void> execute(AuthData authData, Ref ref) async {
    final manager = ref.read(versionManagerProvider);
    await manager.checkVersionAndCleanup();
  }
}
