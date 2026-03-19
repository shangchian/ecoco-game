import 'dart:convert';
import 'package:flutter/services.dart';

import '/models/coupon_rule.dart';
import '/models/coupon_status_model.dart';
import '/services/interface/i_coupon_rules_service.dart';

class CouponRulesServiceMock implements ICouponRulesService {
  // Cache for loaded data
  List<CouponRule>? _cachedRules;

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<CouponRulesResponse> fetchCouponRules({
    String? etag,
    String? lastModified,
  }) async {
    await _simulateNetworkDelay();

    // Simulate 304 response if etag matches
    if (etag == 'mock-etag-coupon-rules') {
      throw CacheNotModifiedException();
    }

    final rules = await loadBundledCouponRules();
    return CouponRulesResponse(
      couponRules: rules,
      etag: 'mock-etag-coupon-rules',
      lastModified: DateTime.now().toUtc().toIso8601String(),
    );
  }

  @override
  Future<List<CouponRule>> loadBundledCouponRules() async {
    if (_cachedRules != null) return _cachedRules!;

    final jsonString =
        await rootBundle.loadString('assets/data/coupon-rules.json');
    final dynamic json = jsonDecode(jsonString);

    List<dynamic> rulesList;
    if (json is List) {
      rulesList = json;
    } else if (json is Map && json.containsKey('result')) {
      rulesList = json['result'];
    } else {
      throw Exception('Unexpected format in bundled coupon-rules.json');
    }

    _cachedRules = rulesList.map((item) => CouponRule.fromJson(item)).toList();
    return _cachedRules!;
  }

  @override
  Future<CouponStatusListResponse> getCouponStatusList() async {
    await _simulateNetworkDelay();

    // Return all active coupon rules as NORMAL status
    final rules = await loadBundledCouponRules();
    final statusList = rules
        .where((r) => r.isActive)
        .map((r) => CouponStatusItem(
              couponRuleId: r.id,
              displayStatus: DisplayStatus.normal,
            ))
        .toList();

    return CouponStatusListResponse(couponStatusList: statusList);
  }
}
