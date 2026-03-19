import 'package:json_annotation/json_annotation.dart';
import 'member_coupon_model.dart';

part 'finalize_coupon_response.g.dart';

@JsonSerializable()
class FinalizeCouponResponse {
  final String memberCouponId;
  
  @JsonKey(name: 'newStatus')
  final MemberCouponStatus status;
  
  final String usedAt;

  const FinalizeCouponResponse({
    required this.memberCouponId,
    required this.status,
    required this.usedAt,
  });

  factory FinalizeCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$FinalizeCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinalizeCouponResponseToJson(this);
}
