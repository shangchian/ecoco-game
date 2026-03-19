import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/coupon_rule.dart';
import '/models/coupon_status_model.dart';
import '/services/s3_storage_service.dart';
import '/services/online/base_service.dart';
import '/services/interface/i_coupon_rules_service.dart';
import '/utils/json_parsing_utils.dart';
import '/flavors.dart';

class CouponRulesService extends BaseService implements ICouponRulesService {
  final _s3Service = S3StorageService();

  CouponRulesService({
    super.onTokenRefreshed,
    super.onRefreshFailed,
  });

  @override
  Future<CouponRulesResponse> fetchCouponRules({String? etag, String? lastModified}) async {
    try {
      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.couponRulesUrl}?t=$timestamp';

      final response = await _s3Service.fetchFromS3(
        url: url,
        etag: etag,
        lastModified: lastModified,
      );

      if (response.statusCode == 304) {
        throw CacheNotModifiedException();
      }

      if (response.statusCode == 403) {
        throw CouponRulesFetchException('Coupon rules file not found on S3 (403)');
      }

      if (response.statusCode == 200) {
        final newEtag = response.headers.value('etag');
        final newLastModified = response.headers.value('last-modified');

        final dynamic data = response.data;
        List<CouponRule> couponRules;

        if (data is List) {
          couponRules = await _parseCouponRules(data);
        } else if (data is Map && data.containsKey('result')) {
          final List<dynamic> resultList = data['result'];
          couponRules = await _parseCouponRules(resultList);
        } else {
          throw CouponRulesFetchException('Unexpected response format from S3');
        }

        return CouponRulesResponse(
          couponRules: couponRules,
          etag: newEtag,
          lastModified: newLastModified,
        );
      }

      throw CouponRulesFetchException('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      log('Error fetching coupon rules: $e');
      rethrow;
    }
  }

  /// Parse coupon rules from JSON
  Future<List<CouponRule>> _parseCouponRules(List<dynamic> jsonList) async {
    return jsonList.map((json) => CouponRule.fromJson(json)).toList();
  }

  @override
  Future<List<CouponRule>> loadBundledCouponRules() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/coupon-rules.json');
      final dynamic json = jsonDecode(jsonString);

      List<dynamic> couponRulesList;
      if (json is List) {
        couponRulesList = json;
      } else if (json is Map && json.containsKey('result')) {
        couponRulesList = json['result'];
      } else {
        throw Exception('Unexpected format in bundled coupon-rules.json');
      }

      return couponRulesList.map((item) => CouponRule.fromJson(item)).toList();
    } catch (e) {
      log('Error loading bundled coupon rules: $e');
      throw Exception('無法讀取快取的優惠券列表: $e');
    }
  }

  @override
  Future<CouponStatusListResponse> getCouponStatusList() async {
    try {
      final response = await dio.get(
        '/coupon-rules',
      );

      validateResponse(response);

      // Check API response code
      final int code = parseResponseCode(response.data);
      if (code == 0) {
        final List<dynamic> resultList = response.data['result'];
        final items = resultList
            .map((json) => CouponStatusItem.fromJson(json as Map<String, dynamic>))
            .toList();
        return CouponStatusListResponse(couponStatusList: items);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to fetch coupon status',
        );
      }
    } catch (e) {
      log('Error fetching coupon status list: $e');
      throw handleError(e);
    }
  }
}
