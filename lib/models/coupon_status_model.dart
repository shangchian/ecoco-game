import 'package:json_annotation/json_annotation.dart';

part 'coupon_status_model.g.dart';

/// Display status for coupon rules
enum DisplayStatus {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('SOLD_OUT')
  soldOut,
  discontinued,  // Runtime only - not from API, indicates no status record
}

/// Extension for display status
extension DisplayStatusExtension on DisplayStatus {
  String get displayName {
    switch (this) {
      case DisplayStatus.normal:
        return '正常';
      case DisplayStatus.soldOut:
        return '已售罄';
      case DisplayStatus.discontinued:
        return '已結束合作';
    }
  }

  bool get isAvailable => this == DisplayStatus.normal;
  bool get isDiscontinued => this == DisplayStatus.discontinued;
}

/// Individual coupon status item
@JsonSerializable()
class CouponStatusItem {
  final String couponRuleId;
  final DisplayStatus displayStatus;

  CouponStatusItem({
    required this.couponRuleId,
    required this.displayStatus,
  });

  factory CouponStatusItem.fromJson(Map<String, dynamic> json) =>
      _$CouponStatusItemFromJson(json);

  Map<String, dynamic> toJson() => _$CouponStatusItemToJson(this);
}

/// API response wrapper
@JsonSerializable()
class CouponStatusListResponse {
  final List<CouponStatusItem> couponStatusList;

  CouponStatusListResponse({
    required this.couponStatusList,
  });

  factory CouponStatusListResponse.fromJson(Map<String, dynamic> json) =>
      _$CouponStatusListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CouponStatusListResponseToJson(this);
}
