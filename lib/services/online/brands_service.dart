import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/brand_model.dart';
import '/services/s3_storage_service.dart';
import '/services/interface/i_brands_service.dart';
import '/flavors.dart';

class BrandsService implements IBrandsService {
  final _s3Service = S3StorageService();

  @override
  Future<BrandsResponse> fetchBrands({String? etag, String? lastModified}) async {
    try {
      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.brandsUrl}?t=$timestamp';

      final response = await _s3Service.fetchFromS3(
        url: url,
        etag: etag,
        lastModified: lastModified,
      );

      if (response.statusCode == 304) {
        throw CacheNotModifiedException();
      }

      if (response.statusCode == 403) {
        throw BrandFetchException('Brands file not found on S3 (403)');
      }

      if (response.statusCode == 200) {
        final newEtag = response.headers.value('etag');
        final newLastModified = response.headers.value('last-modified');

        final dynamic data = response.data;
        List<Brand> brands;

        if (data is List) {
          brands = await _parseBrands(data);
        } else if (data is Map && data.containsKey('result')) {
          final List<dynamic> resultList = data['result'];
          brands = await _parseBrands(resultList);
        } else {
          throw BrandFetchException('Unexpected response format from S3');
        }

        return BrandsResponse(
          brands: brands,
          etag: newEtag,
          lastModified: newLastModified,
        );
      }

      throw BrandFetchException('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      log('Error fetching brands: $e');
      rethrow;
    }
  }

  /// Parse brands from JSON
  Future<List<Brand>> _parseBrands(List<dynamic> jsonList) async {
    return jsonList.map((json) => Brand.fromJson(json)).toList();
  }

  @override
  Future<List<Brand>> loadBundledBrands() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/brands.json');
      final dynamic json = jsonDecode(jsonString);

      List<dynamic> brandsList;
      if (json is List) {
        brandsList = json;
      } else if (json is Map && json.containsKey('result')) {
        brandsList = json['result'];
      } else {
        throw Exception('Unexpected format in bundled brands.json');
      }

      return brandsList.map((item) => Brand.fromJson(item)).toList();
    } catch (e) {
      log('Error loading bundled brands: $e');
      throw Exception('無法讀取快取的商家列表: $e');
    }
  }
}
