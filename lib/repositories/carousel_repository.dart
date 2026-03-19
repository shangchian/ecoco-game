import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants/carousel_constants.dart';
import '/database/app_database.dart';
import '/models/carousel_model.dart';
import '/services/interface/i_carousels_service.dart';
import '/services/online/carousels_service.dart';

class CarouselRepository {
  final AppDatabase _db;
  final ICarouselsService _carouselsService;

  static const String _carouselsEtagKey = 'carousels_etag';
  static const String _carouselsLastModifiedKey = 'carousels_last_modified';
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  CarouselRepository({
    required AppDatabase db,
    ICarouselsService? carouselsService,
  })  : _db = db,
        _carouselsService = carouselsService ?? CarouselsService();

  // ========== Reactive Streams ==========

  /// Watch carousels by placement key (filtered by date validity)
  Stream<List<CarouselModel>> watchCarouselsByPlacement(String placementKey) {
    return _db.watchCarouselsByPlacement(placementKey);
  }

  /// Watch active main carousels (HOME_MAIN_CAROUSEL)
  Stream<List<CarouselModel>> watchActiveMainCarousels() {
    return watchCarouselsByPlacement(CarouselPlacement.homeMainCarousel);
  }

  /// Watch active popup modals (HOME_POPUP_MODAL)
  Stream<List<CarouselModel>> watchActivePopupModals() {
    return watchCarouselsByPlacement(CarouselPlacement.homePopupModal);
  }

  // ========== Synchronization ==========

  /// Sync carousels from S3 (upsert + cleanup + conditional request)
  Future<void> syncCarousels({bool forceRefresh = false}) async {
    try {
      final cachedAt = await _db.getLatestCarouselCachedAt();

      if (!forceRefresh && cachedAt != null && _isCacheValid(cachedAt)) {
        log('Carousels cache is valid, skipping sync');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final etag = prefs.getString(_carouselsEtagKey);
      final lastModified = prefs.getString(_carouselsLastModifiedKey);

      try {
        final response = await _carouselsService.fetchCarousels(
          etag: etag,
          lastModified: lastModified,
        );

        log('Fetched ${response.carousels.length} carousels from S3');

        // Upsert carousels
        await _db.upsertCarousels(response.carousels);

        // Delete carousels not in the response (cleanup)
        final carouselIds = response.carousels.map((c) => c.id).toList();
        await _db.deleteCarouselsNotInList(carouselIds);

        // Save new ETag and Last-Modified headers
        if (response.etag != null) {
          await prefs.setString(_carouselsEtagKey, response.etag!);
        }
        if (response.lastModified != null) {
          await prefs.setString(_carouselsLastModifiedKey, response.lastModified!);
        }

        log('Synced ${response.carousels.length} carousels successfully');
      } on CacheNotModifiedException {
        log('Carousels not modified (304), using existing database data');
      }
    } catch (e) {
      log('Error syncing carousels: $e');

      // Fallback: Load bundled assets if database is empty
      final existingCarousels = await _db
          .watchCarouselsByPlacement(CarouselPlacement.homeMainCarousel)
          .first;
      if (existingCarousels.isEmpty) {
        log('Database empty, loading bundled carousels');
        try {
          final bundledCarousels = await _carouselsService.loadBundledCarousels();
          await _db.upsertCarousels(bundledCarousels);
          log('Loaded ${bundledCarousels.length} bundled carousels into database');
        } catch (e2) {
          log('Failed to load bundled carousels: $e2');
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

  /// Clear cache (Deep Clean)
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_carouselsEtagKey);
      await prefs.remove(_carouselsLastModifiedKey);
      
      // Deep Clean
      await _db.clearAllCarousels();
      
      log('[CarouselRepository] Cleared cache headers and DB (Deep Clean)');
    } catch (e) {
      log('[CarouselRepository] Error clearing cache: $e');
    }
  }
}
