import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/member_delete_reason_model.dart';
import '/services/interface/i_delete_reasons_service.dart';
import '/flavors.dart';

/// Service for managing member delete reasons list
/// - Loads from bundled asset as fallback
/// - Fetches from AWS S3 and caches based on Last-Modified header
class MemberDeleteReasonsService implements IDeleteReasonsService {
  static const String _lastModifiedKey = 'member_delete_reasons_last_modified';
  static const String _cachedDataKey = 'member_delete_reasons_cached_data';
  static const String _assetPath = 'assets/data/member-delete-reasons.json';

  /// Get delete reasons from cache or fetch from S3
  @override
  Future<DeleteReasonsResponse> getDeleteReasons() async {
    try {
      // For mock flavor, always use bundled asset
      if (F.appFlavor == Flavor.mock || F.deleteReasonsUrl.isEmpty) {
        return await _loadFromAsset();
      }

      // Try to fetch from S3 with caching
      return await _fetchFromS3WithCache();
    } catch (e) {
      log('[MemberDeleteReasonsService] Error getting delete reasons: $e');
      // Fallback to bundled asset
      return await _loadFromAsset();
    }
  }

  /// Fetch from S3 with Last-Modified caching
  Future<DeleteReasonsResponse> _fetchFromS3WithCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedLastModified = prefs.getString(_lastModifiedKey);
      final cachedData = prefs.getString(_cachedDataKey);

      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.deleteReasonsUrl}?t=$timestamp';

      // Check Last-Modified header from S3
      final dio = Dio();
      final headResponse = await dio.head(
        url,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final s3LastModified = headResponse.headers.value('last-modified');

      // If Last-Modified is same and we have cached data, use cache
      if (s3LastModified != null &&
          s3LastModified == storedLastModified &&
          cachedData != null) {
        log('[MemberDeleteReasonsService] Using cached data (Last-Modified: $s3LastModified)');
        final jsonData = jsonDecode(cachedData);
        return DeleteReasonsResponse.fromJson(jsonData);
      }

      // Fetch new data from S3
      log('[MemberDeleteReasonsService] Fetching from S3 (Last-Modified changed or no cache)');
      final getResponse = await dio.get(
        url,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (getResponse.statusCode == 200) {
        final jsonString = jsonEncode(getResponse.data);

        // Save to cache
        await prefs.setString(_cachedDataKey, jsonString);
        if (s3LastModified != null) {
          await prefs.setString(_lastModifiedKey, s3LastModified);
        }

        log('[MemberDeleteReasonsService] Fetched and cached new data from S3');
        return DeleteReasonsResponse.fromJson(getResponse.data);
      } else {
        throw Exception('S3 request failed with status ${getResponse.statusCode}');
      }
    } catch (e) {
      log('[MemberDeleteReasonsService] S3 fetch failed: $e, falling back to asset');
      // If S3 fails but we have cached data, use it
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cachedDataKey);
      if (cachedData != null) {
        final jsonData = jsonDecode(cachedData);
        return DeleteReasonsResponse.fromJson(jsonData);
      }

      // Otherwise fallback to bundled asset
      return await _loadFromAsset();
    }
  }

  /// Load from bundled asset file
  Future<DeleteReasonsResponse> _loadFromAsset() async {
    log('[MemberDeleteReasonsService] Loading from bundled asset');
    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonData = jsonDecode(jsonString);
    return DeleteReasonsResponse.fromJson(jsonData);
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastModifiedKey);
      await prefs.remove(_cachedDataKey);
      log('[MemberDeleteReasonsService] Cache cleared');
    } catch (e) {
      log('[MemberDeleteReasonsService] Error clearing cache: $e');
    }
  }
}
