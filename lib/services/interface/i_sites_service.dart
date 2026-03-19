import '/models/site_model.dart';
import '/models/site_status_model.dart';

/// Custom exception thrown when S3 returns 304 Not Modified
class CacheNotModifiedException implements Exception {
  final String message;
  CacheNotModifiedException([this.message = 'Cache not modified']);

  @override
  String toString() => message;
}

/// Custom exception for site fetch errors
class SiteFetchException implements Exception {
  final String message;
  SiteFetchException(this.message);

  @override
  String toString() => message;
}

/// Interface for sites service
abstract class ISitesService {
  /// Fetch sites from S3 with optional ETag/Last-Modified for conditional requests
  /// Throws CacheNotModifiedException if 304 Not Modified response
  /// Returns SitesResponse with sites data and new cache headers
  Future<SitesResponse> fetchSites({String? etag, String? lastModified});

  /// Fetch site statuses from API
  Future<List<SiteStatus>> fetchSiteStatuses({
    int? areaId,
    int? districtId,
  });

  /// Load bundled sites from assets as fallback
  Future<List<Site>> loadBundledSites();
}

/// Response wrapper that includes both sites data and cache headers
class SitesResponse {
  final List<Site> sites;
  final String? etag;
  final String? lastModified;

  SitesResponse({
    required this.sites,
    this.etag,
    this.lastModified,
  });
}
