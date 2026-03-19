import 'package:json_annotation/json_annotation.dart';

part 'member_limits_response.g.dart';

/// Response model for getMemberLimits API
/// GET /coupons/{couponRuleId}/member-limits
@JsonSerializable()
class MemberLimitsResponse {
  /// 優惠券規則 UID
  final String couponRuleId;

  /// 是否可以兌換此優惠券
  final bool isExchangeable;

  /// 會員最多可以兌換多少 Units
  /// 此值為考慮會員點數、優惠券規則限制後的計算結果
  final int maxExchangeableUnits;

  /// 前端顯示之不符合原因描述
  /// 例如：已達兌換上限 (3張)、點數餘額不足、活動尚未開始、不符合兌換資格、優惠券已被兌換完畢
  final String? reasonMessage;

  const MemberLimitsResponse({
    required this.couponRuleId,
    required this.isExchangeable,
    required this.maxExchangeableUnits,
    this.reasonMessage,
  });

  factory MemberLimitsResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberLimitsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberLimitsResponseToJson(this);
}
