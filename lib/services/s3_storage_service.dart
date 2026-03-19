import 'dart:developer';
import 'package:dio/dio.dart';
import '/flavors.dart';

/// Generic service for fetching data from S3 storage with ETag caching support
class S3StorageService {
  // Singleton pattern to reuse Dio instance
  static final S3StorageService _instance = S3StorageService._internal();
  factory S3StorageService() => _instance;

  late final Dio _dio;

  S3StorageService._internal() {
    _dio = Dio(BaseOptions(
      validateStatus: (status) => status != null && status < 500,
    ));
  }

  /// Fetch data from S3 with optional ETag/Last-Modified headers for conditional requests
  /// Returns the full Response object so caller can check status and extract headers
  Future<Response> fetchFromS3({
    required String url,
    String? etag,
    String? lastModified,
  }) async {
    try {
      if (url.isEmpty) {
        throw Exception('S3 URL is empty');
      }

      final headers = <String, String>{};
      if (etag != null && etag.isNotEmpty) {
        headers['If-None-Match'] = etag;
      }
      if (lastModified != null && lastModified.isNotEmpty) {
        headers['If-Modified-Since'] = lastModified;
      }

      log('Fetching from S3: $url with headers: $headers');

      final response = await _dio.get(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );

      log('S3 response status: ${response.statusCode}');
      return response;
    } catch (e) {
      log('Error fetching from S3: $e');
      rethrow;
    }
  }

  /// Fetch sites from S3 with optional ETag/Last-Modified headers for conditional requests
  /// Returns the full Response object so caller can check status and extract headers
  @Deprecated('Use fetchFromS3 with url parameter instead')
  Future<Response> fetchSites({
    String? etag,
    String? lastModified,
  }) async {
    return fetchFromS3(
      url: F.sitesUrl,
      etag: etag,
      lastModified: lastModified,
    );
  }
}
