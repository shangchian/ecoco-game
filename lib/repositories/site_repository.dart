import 'dart:developer';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/database/app_database.dart';
import '/models/site_model.dart';
import '/providers/auth_provider.dart';
import '/services/interface/i_sites_service.dart';

/// Exception thrown when user attempts to exceed the maximum favorite sites limit
class FavoriteLimitExceededException implements Exception {
  final String message;

  FavoriteLimitExceededException(this.message);

  @override
  String toString() => message;
}

class SiteRepository {
  final AppDatabase _db;
  final ISitesService _sitesService;

  // SharedPreferences keys (only for ETag/Last-Modified)
  // v2 suffix indicates Drift-based storage (different from old SharedPreferences-based storage)
  static const String _sitesEtagKey = 'sites_etag_v2';
  static const String _sitesLastModifiedKey = 'sites_last_modified_v2';

  static const String _favoritesBackupKey = 'backup_favorite_sites_v2';
  
  // Cache validity duration
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  SiteRepository({
    required AppDatabase db,
    required ISitesService sitesService,
  })  : _db = db,
        _sitesService = sitesService;

  // ========== Reactive Streams ==========

  /// Watch all sites (reactive stream)
  Stream<List<Site>> watchAllSites() {
    return _db.watchSites();
  }

  /// Watch favorite sites (reactive stream)
  Stream<List<Site>> watchFavoriteSites() {
    return _db.watchFavoriteSites();
  }

  /// Watch sites with status merged (reactive stream)
  Stream<List<Site>> watchSitesWithStatus() {
    return _db.watchSitesWithStatus();
  }

  // ========== Sites Synchronization ==========

  /// Sync sites from S3 (upsert + cleanup removed sites)
  Future<void> syncSites({bool forceRefresh = false}) async {
    try {
      // Check cache validity
      final cachedAt = await _db.getLatestSiteCachedAt();

      if (!forceRefresh && cachedAt != null && _isCacheValid(cachedAt)) {
        log('Sites cache is valid, skipping sync');
        // Fluttertoast.showToast(msg: "Sites sync: Cache Valid (Skipped)");
        return;
      }

      // Get ETag and Last-Modified from SharedPreferences for conditional request
      final prefs = await SharedPreferences.getInstance();
      final etag = prefs.getString(_sitesEtagKey);
      final lastModified = prefs.getString(_sitesLastModifiedKey);

      try {
        // Fetch from S3 with conditional request
        final response = await _sitesService.fetchSites(
          etag: etag,
          lastModified: lastModified,
        );

        log('Fetched ${response.sites.length} sites from S3');

        // Upsert sites to database
        await _db.upsertSites(response.sites);

        // Remove sites that no longer exist
        final newSiteIds = response.sites.map((s) => s.id).toList();
        await _db.removeSitesNotInList(newSiteIds);

        // Save new ETag/Last-Modified to SharedPreferences
        if (response.etag != null) {
          await prefs.setString(_sitesEtagKey, response.etag!);
        }
        if (response.lastModified != null) {
          await prefs.setString(_sitesLastModifiedKey, response.lastModified!);
        }

        // --- Restore Favorites from Backup if needed ---
        final currentFavorites = await _db.getFavoriteCodes();
        if (currentFavorites.isEmpty) {
          final backupFavorites = prefs.getStringList(_favoritesBackupKey);
          if (backupFavorites != null && backupFavorites.isNotEmpty) {
            log('[SiteRepository] Restoring ${backupFavorites.length} favorites from backup');
            for (final code in backupFavorites) {
              await _db.setFavorite(code, true);
            }
            // Clear backup after successful restore
            await prefs.remove(_favoritesBackupKey);
          }
        }

        log('Synced ${response.sites.length} sites successfully');
        // Fluttertoast.showToast(msg: "Sites sync: 200 OK (Updated)");
      } on CacheNotModifiedException {
        // 304 response - sites not modified, database already has latest data
        log('Sites not modified (304), using existing database data');
        // Fluttertoast.showToast(msg: "Sites sync: 304 Not Modified");
      }
    } catch (e) {
      log('Error syncing sites: $e');
      // Graceful degradation - continue using local database data

      // Fallback: Load bundled assets if database is empty
      final existingSites = await _db.watchSites().first;
      if (existingSites.isEmpty) {
        log('Database empty, loading bundled sites');
        try {
          final bundledSites = await _sitesService.loadBundledSites();
          await _db.upsertSites(bundledSites);
          log('Loaded ${bundledSites.length} bundled sites into database');
        } catch (e2) {
          log('Failed to load bundled sites: $e2');
        }
      }
    }
  }

  /// Sync site statuses from API
  Future<void> syncSiteStatuses({bool forceRefresh = false}) async {
    try {
      // Clear expired statuses first
      if (!forceRefresh) {
        await _db.clearExpiredStatuses();
      }

      // Fetch statuses from API
      final statuses = await _sitesService.fetchSiteStatuses();

      // Upsert to database
      await _db.upsertSiteStatuses(statuses);

      log('Synced ${statuses.length} site statuses');
    } catch (e) {
      if (e is NotAuthenticatedException) {
        return;
      }
      log('Error syncing site statuses: $e');
      // Graceful degradation - continue using existing status data
    }
  }

  // ========== Favorites Management ==========

  /// Add a site to favorites
  Future<void> addFavorite(String siteCode) async {
    try {
      // Check current favorite count before adding
      final favoriteCodes = await _db.getFavoriteCodes();

      // Allow if already favorited (defensive check)
      if (!favoriteCodes.contains(siteCode) && favoriteCodes.length >= 5) {
        throw FavoriteLimitExceededException('已達收藏上限');
      }

      await _db.setFavorite(siteCode, true);
      log('Added favorite: $siteCode');
    } catch (e) {
      log('Error adding favorite: $e');
      rethrow;
    }
  }

  /// Remove a site from favorites
  Future<void> removeFavorite(String siteCode) async {
    try {
      await _db.setFavorite(siteCode, false);
      log('Removed favorite: $siteCode');
    } catch (e) {
      log('Error removing favorite: $e');
      rethrow;
    }
  }

  /// Check if a site is favorited
  Future<bool> isFavorite(String siteCode) async {
    final codes = await _db.getFavoriteCodes();
    return codes.contains(siteCode);
  }

  // ========== Utility Methods ==========

  /// Check if cache is still valid
  bool _isCacheValid(DateTime cachedAt) {
    final age = DateTime.now().difference(cachedAt);
    return age < _cacheValidityDuration;
  }

  /// Clear site statuses on logout (Sites are NOT cleared)
  Future<void> clearStatusesOnLogout() async {
    try {
      await _db.clearAllStatuses();
      log('Cleared site statuses on logout');
    } catch (e) {
      log('Error clearing statuses on logout: $e');
    }
  }

  /// Clear all cache data (Deep Clean)
  /// Wipes database table but backs up favorites first
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Backup Favorites
      final favorites = await _db.getFavoriteCodes();
      if (favorites.isNotEmpty) {
        await prefs.setStringList(_favoritesBackupKey, favorites);
        log('[SiteRepository] Backed up ${favorites.length} favorites');
      }

      // 2. Clear Headers
      await prefs.remove(_sitesEtagKey);
      await prefs.remove(_sitesLastModifiedKey);
      
      // 3. Deep Clean DB
      await _db.clearAllSites(); // New method
      await _db.clearAllStatuses();
      
      log('[SiteRepository] Cleared all site cache (Deep Clean)');
    } catch (e) {
      log('Error clearing all cache: $e');
    }
  }
}
