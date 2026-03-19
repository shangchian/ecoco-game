import 'package:json_annotation/json_annotation.dart';

part 'issue_coupon_response.g.dart';

/// Response model for issueCoupon API
/// POST /exchange/coupons/{couponRuleId}/issue
@JsonSerializable()
class IssueCouponResponse {
  /// 優惠券規則 UID
  final String couponRuleId;

  /// 會員兌換的單位數量
  final int exchangeUnits;

  /// 總扣除的會員點數額
  final int totalCost;

  /// 發行的會員優惠券資產數量
  final int issuedCount;

  /// 發行的會員優惠券資產 UID 陣列
  final List<String> issuedMemberCouponIds;

  const IssueCouponResponse({
    required this.couponRuleId,
    required this.exchangeUnits,
    required this.totalCost,
    required this.issuedCount,
    required this.issuedMemberCouponIds,
  });

  factory IssueCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$IssueCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IssueCouponResponseToJson(this);
}
