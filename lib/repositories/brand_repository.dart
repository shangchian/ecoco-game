import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '/database/app_database.dart';
import '/models/brand_model.dart';
import '/services/interface/i_brands_service.dart';
import '/services/online/brands_service.dart';

class BrandRepository {
  final AppDatabase _db;
  final IBrandsService _brandsService;

  static const String _brandsEtagKey = 'brands_etag';
  static const String _brandsLastModifiedKey = 'brands_last_modified';
  static const Duration _cacheValidityDuration = Duration(minutes: 30);

  BrandRepository({
    required AppDatabase db,
    IBrandsService? brandsService,
  })  : _db = db,
        _brandsService = brandsService ?? BrandsService();

  // ========== Reactive Streams ==========

  /// Watch all active brands (sorted by sortOrder)
  Stream<List<Brand>> watchActiveBrands() {
    return _db.watchActiveBrands();
  }

  /// Watch premium brands for home carousel
  Stream<List<Brand>> watchPremiumBrands() {
    return _db.watchPremiumBrands();
  }

  /// Watch brands by specific category
  Stream<List<Brand>> watchBrandsByCategory(BrandCategory category) {
    return _db.watchActiveBrandsByCategory(category);
  }

  /// Watch a single brand by ID
  Stream<Brand?> watchBrandById(String brandId) {
    return _db.watchBrandById(brandId);
  }

  // ========== Synchronization ==========

  /// Sync brands from S3 (upsert + conditional request)
  Future<void> syncBrands({bool forceRefresh = false}) async {
    try {
      final cachedAt = await _db.getLatestBrandCachedAt();

      if (!forceRefresh && cachedAt != null && _isCacheValid(cachedAt)) {
        log('Brands cache is valid, skipping sync');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final etag = prefs.getString(_brandsEtagKey);
      final lastModified = prefs.getString(_brandsLastModifiedKey);

      try {
        final response = await _brandsService.fetchBrands(
          etag: etag,
          lastModified: lastModified,
        );

        log('Fetched ${response.brands.length} brands from S3');

        await _db.upsertBrands(response.brands);

        if (response.etag != null) {
          await prefs.setString(_brandsEtagKey, response.etag!);
        }
        if (response.lastModified != null) {
          await prefs.setString(_brandsLastModifiedKey, response.lastModified!);
        }

        log('Synced ${response.brands.length} brands successfully');
      } on CacheNotModifiedException {
        log('Brands not modified (304), using existing database data');
      }
    } catch (e) {
      log('Error syncing brands: $e');

      // Fallback: Load bundled assets if database is empty
      final existingBrands = await _db.watchActiveBrands().first;
      if (existingBrands.isEmpty) {
        log('Database empty, loading bundled brands');
        try {
          final bundledBrands = await _brandsService.loadBundledBrands();
          await _db.upsertBrands(bundledBrands);
          log('Loaded ${bundledBrands.length} bundled brands into database');
        } catch (e2) {
          log('Failed to load bundled brands: $e2');
        }
      }
    }
  }

  // ========== Utility Methods ==========

  /// Check if cache is still valid
  bool _isCacheValid(DateTime cachedAt) {
    final age = DateTime.now().difference(cachedAt);
    return age < _cacheValidityDuration;
  }

  /// Clear all cache data (Deep Clean)
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_brandsEtagKey);
      await prefs.remove(_brandsLastModifiedKey);
      
      // Deep Clean
      await _db.clearAllBrands();
      
      log('[BrandRepository] Cleared brand cache (Deep Clean)');
    } catch (e) {
      log('Error clearing brand cache: $e');
    }
  }
}
