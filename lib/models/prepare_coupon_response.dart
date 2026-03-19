import 'package:json_annotation/json_annotation.dart';

part 'prepare_coupon_response.g.dart';

/// Response model for prepareCoupon API
/// POST /exchange/coupons/{couponRuleId}/prepare
///
/// 建立待核銷的優惠券，狀態為 HOLDING，有效期限為5分鐘
@JsonSerializable()
class PrepareCouponResponse {
  /// 建立待核銷的會員優惠券資產 UID
  /// 等同 POS API 中的 scanToken
  final String memberCouponId;

  /// 優惠券規則 UID
  final String couponRuleId;

  /// 會員兌換的單位數量（必須大於等於1）
  @JsonKey(name: 'exchangedUnits')
  final int exchangedUnits;

  /// 總扣除的會員點數數額
  final int totalCost;

  /// 舊POS API中的scanToken，如為Null則表示該優惠使用的已是新POS API
  /// 臨時欄位，舊POS API關閉後需移除
  final String? legacyPosScanToken;

  const PrepareCouponResponse({
    required this.memberCouponId,
    required this.couponRuleId,
    required this.exchangedUnits,
    required this.totalCost,
    this.legacyPosScanToken,
  });

  factory PrepareCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$PrepareCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrepareCouponResponseToJson(this);
}
