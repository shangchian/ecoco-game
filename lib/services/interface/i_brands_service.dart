import '/models/brand_model.dart';

/// Exception thrown when cache is not modified (304 response)
class CacheNotModifiedException implements Exception {
  final String message;
  CacheNotModifiedException([this.message = 'Cache not modified']);

  @override
  String toString() => message;
}

/// Exception thrown when brand fetch fails
class BrandFetchException implements Exception {
  final String message;
  BrandFetchException(this.message);

  @override
  String toString() => message;
}

/// Interface for brands service
abstract class IBrandsService {
  /// Fetch brands from S3 with conditional request support
  Future<BrandsResponse> fetchBrands({String? etag, String? lastModified});

  /// Load brands from bundled assets
  Future<List<Brand>> loadBundledBrands();
}

/// Response from fetchBrands
class BrandsResponse {
  final List<Brand> brands;
  final String? etag;
  final String? lastModified;

  BrandsResponse({
    required this.brands,
    this.etag,
    this.lastModified,
  });
}
