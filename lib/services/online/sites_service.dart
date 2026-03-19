import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/site_model.dart';
import '/models/site_status_model.dart';
import '/services/s3_storage_service.dart';
import '/services/interface/i_sites_service.dart';
import '/flavors.dart';
import 'base_service.dart';

class SitesService extends BaseService implements ISitesService {
  SitesService({
    super.onTokenRefreshed,
    super.onRefreshFailed,
  });

  final _s3Service = S3StorageService();

  @override
  Future<SitesResponse> fetchSites({String? etag, String? lastModified}) async {
    try {
      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.sitesUrl}?t=$timestamp';

      final response = await _s3Service.fetchFromS3(
        url: url,
        etag: etag,
        lastModified: lastModified,
      );

      // Handle 304 Not Modified
      if (response.statusCode == 304) {
        throw CacheNotModifiedException();
      }

      // Handle 403 Forbidden (file not found)
      if (response.statusCode == 403) {
        throw SiteFetchException('Sites file not found on S3 (403)');
      }

      // Handle success (200)
      if (response.statusCode == 200) {
        // Extract new ETag and Last-Modified headers
        final newEtag = response.headers.value('etag');
        final newLastModified = response.headers.value('last-modified');

        // Parse sites from response
        final dynamic data = response.data;
        List<Site> sites;

        if (data is List) {
          sites = data.map((json) => Site.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('result')) {
          // Handle format: { "result": [...] }
          final List<dynamic> resultList = data['result'];
          sites = resultList.map((json) => Site.fromJson(json)).toList();
        } else {
          throw SiteFetchException('Unexpected response format from S3');
        }

        return SitesResponse(
          sites: sites,
          etag: newEtag,
          lastModified: newLastModified,
        );
      }

      throw SiteFetchException(
          'Unexpected status code: ${response.statusCode}');
    } catch (e) {
      log('Error fetching sites: $e');
      rethrow;
    }
  }

  @override
  Future<List<SiteStatus>> fetchSiteStatuses({
    int? areaId,
    int? districtId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (areaId != null) queryParams['area_id'] = areaId;
      if (districtId != null) queryParams['district_id'] = districtId;

      // 開會決議：在測試時採用正式站的資料
      /*
      // Create a temporary Dio instance without baseUrl to avoid URL concatenation
      // This is the ONLY API endpoint that requires this special handling
      final tempDio = Dio(BaseOptions(
        validateStatus: (status) => status != null,
      ));
      */

      final response = await dio.get(
        '${F.siteStatusApiBaseUrl}/sites',
        queryParameters: queryParams,
      );

      validateResponse(response);

      // Parse new API structure: response.data['result']['siteStatusList']
      final dynamic result = response.data['result'];
      if (result == null) {
        log('Warning: result is null in site status response');
        return [];
      }

      List<dynamic>? siteStatusList;
      
      if (result is List) {
        siteStatusList = result;
      } else if (result is Map && result.containsKey('siteStatusList')) {
        siteStatusList = result['siteStatusList'];
      }

      if (siteStatusList == null) {
        log('Warning: siteStatusList is null or format invalid in response');
        return [];
      }

      return siteStatusList.map((json) => SiteStatus.fromJson(json)).toList();
    } catch (e) {
      log('Error getting site statuses: $e');
      throw handleError(e);
    }
  }

  @override
  Future<List<Site>> loadBundledSites() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/sites.json');
      final dynamic json = jsonDecode(jsonString);

      List<Site> sites;
      if (json is List) {
        sites = json.map((item) => Site.fromJson(item)).toList();
      } else if (json is Map && json.containsKey('result')) {
        final List<dynamic> resultList = json['result'];
        sites = resultList.map((item) => Site.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected format in bundled sites.json');
      }

      return sites;
    } catch (e) {
      log('Error loading bundled sites: $e');
      throw Exception('無法讀取快取的站點列表: $e');
    }
  }
}
