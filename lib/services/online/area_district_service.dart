import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/area_district_model.dart';
import '/services/s3_storage_service.dart';
import '/services/interface/i_area_district_service.dart';
import '/services/interface/i_sites_service.dart';
import '/flavors.dart';

class AreaDistrictService implements IAreaDistrictService {
  final _s3Service = S3StorageService();

  @override
  Future<AreaDistrictServiceResponse> fetchAreaDistrict({
    String? etag,
    String? lastModified,
  }) async {
    try {
      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.areaDistrictUrl}?t=$timestamp';

      final response = await _s3Service.fetchFromS3(
        url: url,
        etag: etag,
        lastModified: lastModified,
      );

      // Handle 304 Not Modified
      if (response.statusCode == 304) {
        throw CacheNotModifiedException('Area/District cache not modified');
      }

      // Handle 403 Forbidden (file not found)
      if (response.statusCode == 403) {
        throw AreaDistrictFetchException(
            'Area/District file not found on S3 (403)');
      }

      // Handle success (200)
      if (response.statusCode == 200) {
        // Extract new ETag and Last-Modified headers
        final newEtag = response.headers.value('etag');
        final newLastModified = response.headers.value('last-modified');

        // Parse area/district from response
        final dynamic data = response.data;
        final AreaDistrictResponse areaDistrictResponse;

        if (data is Map && data.containsKey('result')) {
          // Handle format: { "result": { "all": [...], "stationOnly": [...] } }
          areaDistrictResponse = AreaDistrictResponse.fromJson(data as Map<String, dynamic>);
        } else {
          throw AreaDistrictFetchException(
              'Unexpected response format from S3');
        }

        return AreaDistrictServiceResponse(
          data: areaDistrictResponse,
          etag: newEtag,
          lastModified: newLastModified,
        );
      }

      throw AreaDistrictFetchException(
          'Unexpected status code: ${response.statusCode}');
    } catch (e) {
      log('Error fetching area/district: $e');
      rethrow;
    }
  }

  @override
  Future<AreaDistrictResponse> loadBundledAreaDistrict() async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/data/area-district-list.json');
      final dynamic json = jsonDecode(jsonString);

      if (json is Map && json.containsKey('result')) {
        return AreaDistrictResponse.fromJson(json as Map<String, dynamic>);
      } else {
        throw Exception('Unexpected format in bundled area-district-list.json');
      }
    } catch (e) {
      log('Error loading bundled area/district: $e');
      throw Exception('無法讀取快取的縣市鄉鎮區列表: $e');
    }
  }
}
