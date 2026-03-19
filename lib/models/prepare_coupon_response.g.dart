// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepare_coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepareCouponResponse _$PrepareCouponResponseFromJson(
  Map<String, dynamic> json,
) => PrepareCouponResponse(
  memberCouponId: json['memberCouponId'] as String,
  couponRuleId: json['couponRuleId'] as String,
  exchangedUnits: (json['exchangedUnits'] as num).toInt(),
  totalCost: (json['totalCost'] as num).toInt(),
  legacyPosScanToken: json['legacyPosScanToken'] as String?,
);

Map<String, dynamic> _$PrepareCouponResponseToJson(
  PrepareCouponResponse instance,
) => <String, dynamic>{
  'memberCouponId': instance.memberCouponId,
  'couponRuleId': instance.couponRuleId,
  'exchangedUnits': instance.exchangedUnits,
  'totalCost': instance.totalCost,
  'legacyPosScanToken': instance.legacyPosScanToken,
};
