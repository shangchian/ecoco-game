import 'package:json_annotation/json_annotation.dart';

part 'member_coupon_status_response.g.dart';

/// Response from get member coupon status API
/// GET /member/coupons/{memberCouponId}/status
@JsonSerializable()
class MemberCouponStatusResponse {
  final String memberCouponId;
  final String couponRuleId;
  final String currentStatus;
  final bool isFinalized;
  final String? finalizedAt;

  MemberCouponStatusResponse({
    required this.memberCouponId,
    required this.couponRuleId,
    required this.currentStatus,
    required this.isFinalized,
    this.finalizedAt,
  });

  factory MemberCouponStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberCouponStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberCouponStatusResponseToJson(this);
}
