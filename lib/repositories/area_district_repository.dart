import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/area_district_model.dart';
import '/services/interface/i_area_district_service.dart';
import '/services/online/area_district_service.dart';
import '/services/interface/i_sites_service.dart';

class AreaDistrictRepository {
  final IAreaDistrictService _areaDistrictService;

  // SharedPreferences keys
  static const String _cacheKey = 'area_district_cache';
  static const String _etagKey = 'area_district_etag';
  static const String _lastModifiedKey = 'area_district_last_modified';
  static const String _cachedAtKey = 'area_district_cached_at';

  // Cache validity duration
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  AreaDistrictRepository({IAreaDistrictService? areaDistrictService})
      : _areaDistrictService = areaDistrictService ?? AreaDistrictService();

  /// Get area/district list from cache or fetch from S3
  Future<AreaDistrictResponse> getAreaDistrict({bool forceRefresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!forceRefresh) {
        // Try to use cached data
        final cached = await _getCachedAreaDistrict(prefs);
        if (cached != null && _isCacheValid(cached.cachedAt)) {
          log('Using cached area/district (${cached.data.result.all.length} areas)');
          return cached.data;
        }
      }

      // Try conditional request with ETag
      final cachedMeta = await _getCachedAreaDistrict(prefs);
      try {
        final response = await _areaDistrictService.fetchAreaDistrict(
          etag: cachedMeta?.etag,
          lastModified: cachedMeta?.lastModified,
        );

        log('Fetched ${response.data.result.all.length} areas from S3');

        // Save with new ETag/Last-Modified
        await _saveAreaDistrictCache(
          prefs,
          response.data,
          response.etag,
          response.lastModified,
        );

        return response.data;
      } on CacheNotModifiedException {
        // 304 response, return cached data
        log('Area/District not modified (304), using cache');
        if (cachedMeta != null) {
          // Update cached-at timestamp
          await prefs.setString(
              _cachedAtKey, DateTime.now().toIso8601String());
          return cachedMeta.data;
        }
        // If no cache, fall through to fallback
      } catch (e) {
        log('Error fetching area/district from S3: $e');
        // Network error, fallback to local data
      }

      // Fallback to local data
      return await _fallbackToLocalData(prefs);
    } catch (e) {
      log('Error in getAreaDistrict: $e');
      // Last resort: try bundled assets
      try {
        return await _areaDistrictService.loadBundledAreaDistrict();
      } catch (e2) {
        log('Failed to load bundled area/district: $e2');
        rethrow;
      }
    }
  }

  /// Clear area/district cache
  Future<void> clearAreaDistrictCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_etagKey);
      await prefs.remove(_lastModifiedKey);
      await prefs.remove(_cachedAtKey);
      log('Area/District cache cleared');
    } catch (e) {
      log('Error clearing area/district cache: $e');
    }
  }

  // ========== Cache Management ==========

  /// Get cached area/district with metadata
  Future<AreaDistrictCache?> _getCachedAreaDistrict(
      SharedPreferences prefs) async {
    try {
      final cacheJson = prefs.getString(_cacheKey);
      final etagJson = prefs.getString(_etagKey);
      final lastModifiedJson = prefs.getString(_lastModifiedKey);
      final cachedAtJson = prefs.getString(_cachedAtKey);

      if (cacheJson == null || cachedAtJson == null) {
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(cacheJson);
      final areaDistrictResponse = AreaDistrictResponse.fromJson(data);

      return AreaDistrictCache(
        data: areaDistrictResponse,
        etag: etagJson,
        lastModified: lastModifiedJson,
        cachedAt: DateTime.parse(cachedAtJson),
      );
    } catch (e) {
      log('Error reading area/district cache: $e');
      return null;
    }
  }

  /// Save area/district cache with metadata
  Future<void> _saveAreaDistrictCache(
    SharedPreferences prefs,
    AreaDistrictResponse data,
    String? etag,
    String? lastModified,
  ) async {
    try {
      final dataJson = jsonEncode(data.toJson());
      await prefs.setString(_cacheKey, dataJson);

      if (etag != null) {
        await prefs.setString(_etagKey, etag);
      }
      if (lastModified != null) {
        await prefs.setString(_lastModifiedKey, lastModified);
      }
      await prefs.setString(_cachedAtKey, DateTime.now().toIso8601String());

      log('Saved ${data.result.all.length} areas to cache');
    } catch (e) {
      log('Error saving area/district cache: $e');
    }
  }

  /// Check if cache is still valid
  bool _isCacheValid(DateTime cachedAt) {
    final now = DateTime.now();
    final diff = now.difference(cachedAt);
    return diff < _cacheValidityDuration;
  }

  /// Fallback to local data when network fails
  Future<AreaDistrictResponse> _fallbackToLocalData(
      SharedPreferences prefs) async {
    log('Falling back to local data');

    // Try cached data first
    final cached = await _getCachedAreaDistrict(prefs);
    if (cached != null) {
      log('Using expired cache (${cached.data.result.all.length} areas)');
      return cached.data;
    }

    // Last resort: load bundled assets
    log('Loading bundled area/district');
    return await _areaDistrictService.loadBundledAreaDistrict();
  }
}
