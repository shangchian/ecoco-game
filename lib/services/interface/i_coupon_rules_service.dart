import '/models/coupon_rule.dart';
import '/models/coupon_status_model.dart';

/// Exception thrown when cache is not modified (304 response)
class CacheNotModifiedException implements Exception {
  final String message;
  CacheNotModifiedException([this.message = 'Cache not modified']);

  @override
  String toString() => message;
}

/// Exception thrown when coupon rules fetch fails
class CouponRulesFetchException implements Exception {
  final String message;
  CouponRulesFetchException(this.message);

  @override
  String toString() => message;
}

/// Interface for coupon rules service
abstract class ICouponRulesService {
  /// Fetch coupon rules from S3 with conditional request support
  Future<CouponRulesResponse> fetchCouponRules({String? etag, String? lastModified});

  /// Load coupon rules from bundled assets
  Future<List<CouponRule>> loadBundledCouponRules();

  /// Get coupon display status from API
  Future<CouponStatusListResponse> getCouponStatusList();
}

/// Response from fetchCouponRules
class CouponRulesResponse {
  final List<CouponRule> couponRules;
  final String? etag;
  final String? lastModified;

  CouponRulesResponse({
    required this.couponRules,
    this.etag,
    this.lastModified,
  });
}
