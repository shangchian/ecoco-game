// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finalize_coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinalizeCouponResponse _$FinalizeCouponResponseFromJson(
  Map<String, dynamic> json,
) => FinalizeCouponResponse(
  memberCouponId: json['memberCouponId'] as String,
  status: $enumDecode(_$MemberCouponStatusEnumMap, json['newStatus']),
  usedAt: json['usedAt'] as String,
);

Map<String, dynamic> _$FinalizeCouponResponseToJson(
  FinalizeCouponResponse instance,
) => <String, dynamic>{
  'memberCouponId': instance.memberCouponId,
  'newStatus': _$MemberCouponStatusEnumMap[instance.status]!,
  'usedAt': instance.usedAt,
};

const _$MemberCouponStatusEnumMap = {
  MemberCouponStatus.unavailable: 'UNAVAILABLE',
  MemberCouponStatus.active: 'ACTIVE',
  MemberCouponStatus.used: 'USED',
  MemberCouponStatus.expired: 'EXPIRED',
  MemberCouponStatus.revoked: 'REVOKED',
  MemberCouponStatus.holding: 'HOLDING',
  MemberCouponStatus.canceled: 'CANCELED',
};
