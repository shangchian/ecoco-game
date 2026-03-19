import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/carousel_model.dart';
import '/services/s3_storage_service.dart';
import '/services/interface/i_carousels_service.dart';
import '/flavors.dart';

class CarouselsService implements ICarouselsService {
  final _s3Service = S3StorageService();

  @override
  Future<CarouselsResponse> fetchCarousels({String? etag, String? lastModified}) async {
    try {
      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.carouselsUrl}?t=$timestamp';

      final response = await _s3Service.fetchFromS3(
        url: url,
        etag: etag,
        lastModified: lastModified,
      );

      if (response.statusCode == 304) {
        throw CacheNotModifiedException();
      }

      if (response.statusCode == 403) {
        throw CarouselFetchException('Carousels file not found on S3 (403)');
      }

      if (response.statusCode == 200) {
        final newEtag = response.headers.value('etag');
        final newLastModified = response.headers.value('last-modified');

        final dynamic data = response.data;
        List<CarouselModel> carousels;

        if (data is List) {
          carousels = await _parseCarousels(data);
        } else if (data is Map && data.containsKey('result')) {
          final List<dynamic> resultList = data['result'];
          carousels = await _parseCarousels(resultList);
        } else {
          throw CarouselFetchException('Unexpected response format from S3');
        }

        return CarouselsResponse(
          carousels: carousels,
          etag: newEtag,
          lastModified: newLastModified,
        );
      }

      throw CarouselFetchException('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      log('Error fetching carousels: $e');
      rethrow;
    }
  }

  /// Parse carousels from JSON
  Future<List<CarouselModel>> _parseCarousels(List<dynamic> jsonList) async {
    return jsonList.map((json) => CarouselModel.fromJson(json)).toList();
  }

  @override
  Future<List<CarouselModel>> loadBundledCarousels() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/carousels.json');
      final dynamic json = jsonDecode(jsonString);

      List<dynamic> carouselsList;
      if (json is List) {
        carouselsList = json;
      } else if (json is Map && json.containsKey('result')) {
        carouselsList = json['result'];
      } else {
        throw Exception('Unexpected format in bundled carousels.json');
      }

      return carouselsList.map((item) => CarouselModel.fromJson(item)).toList();
    } catch (e) {
      log('Error loading bundled carousels: $e');
      rethrow;
    }
  }
}
