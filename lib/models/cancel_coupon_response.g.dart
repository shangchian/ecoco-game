// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelCouponResponse _$CancelCouponResponseFromJson(
  Map<String, dynamic> json,
) => CancelCouponResponse(
  memberCouponId: json['memberCouponId'] as String,
  newStatus: json['newStatus'] as String,
  pointsRefunded: (json['pointsRefunded'] as num).toInt(),
  canceledAt: json['canceledAt'] as String,
);

Map<String, dynamic> _$CancelCouponResponseToJson(
  CancelCouponResponse instance,
) => <String, dynamic>{
  'memberCouponId': instance.memberCouponId,
  'newStatus': instance.newStatus,
  'pointsRefunded': instance.pointsRefunded,
  'canceledAt': instance.canceledAt,
};
