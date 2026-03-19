import 'package:json_annotation/json_annotation.dart';

part 'cancel_coupon_response.g.dart';

/// Response from cancel coupon API
/// POST /exchange/coupons/{memberCouponId}/cancel
@JsonSerializable()
class CancelCouponResponse {
  final String memberCouponId;
  final String newStatus;
  final int pointsRefunded;
  final String canceledAt;

  CancelCouponResponse({
    required this.memberCouponId,
    required this.newStatus,
    required this.pointsRefunded,
    required this.canceledAt,
  });

  factory CancelCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CancelCouponResponseToJson(this);
}
