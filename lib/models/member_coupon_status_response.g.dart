// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_coupon_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberCouponStatusResponse _$MemberCouponStatusResponseFromJson(
  Map<String, dynamic> json,
) => MemberCouponStatusResponse(
  memberCouponId: json['memberCouponId'] as String,
  couponRuleId: json['couponRuleId'] as String,
  currentStatus: json['currentStatus'] as String,
  isFinalized: json['isFinalized'] as bool,
  finalizedAt: json['finalizedAt'] as String?,
);

Map<String, dynamic> _$MemberCouponStatusResponseToJson(
  MemberCouponStatusResponse instance,
) => <String, dynamic>{
  'memberCouponId': instance.memberCouponId,
  'couponRuleId': instance.couponRuleId,
  'currentStatus': instance.currentStatus,
  'isFinalized': instance.isFinalized,
  'finalizedAt': instance.finalizedAt,
};
