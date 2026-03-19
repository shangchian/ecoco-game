import '/models/carousel_model.dart';

/// Exception thrown when cache is not modified (304 response)
class CacheNotModifiedException implements Exception {
  final String message;
  CacheNotModifiedException([this.message = 'Cache not modified']);

  @override
  String toString() => message;
}

/// Exception thrown when carousel fetch fails
class CarouselFetchException implements Exception {
  final String message;
  CarouselFetchException(this.message);

  @override
  String toString() => message;
}

/// Interface for carousels service
abstract class ICarouselsService {
  /// Fetch carousels from S3 with conditional request support
  Future<CarouselsResponse> fetchCarousels({String? etag, String? lastModified});

  /// Load carousels from bundled assets
  Future<List<CarouselModel>> loadBundledCarousels();
}

/// Response from fetchCarousels
class CarouselsResponse {
  final List<CarouselModel> carousels;
  final String? etag;
  final String? lastModified;

  CarouselsResponse({
    required this.carousels,
    this.etag,
    this.lastModified,
  });
}
