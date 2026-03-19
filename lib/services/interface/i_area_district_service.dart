import '/models/area_district_model.dart';

/// Custom exception for area/district fetch errors
class AreaDistrictFetchException implements Exception {
  final String message;
  AreaDistrictFetchException(this.message);

  @override
  String toString() => message;
}

/// Interface for area/district service
abstract class IAreaDistrictService {
  /// Fetch area/district list from S3 with optional ETag/Last-Modified for conditional requests
  /// Throws CacheNotModifiedException if 304 Not Modified response
  /// Returns AreaDistrictServiceResponse with data and new cache headers
  Future<AreaDistrictServiceResponse> fetchAreaDistrict({
    String? etag,
    String? lastModified,
  });

  /// Load bundled area/district from assets as fallback
  Future<AreaDistrictResponse> loadBundledAreaDistrict();
}

/// Response wrapper that includes both area/district data and cache headers
class AreaDistrictServiceResponse {
  final AreaDistrictResponse data;
  final String? etag;
  final String? lastModified;

  AreaDistrictServiceResponse({
    required this.data,
    this.etag,
    this.lastModified,
  });
}
