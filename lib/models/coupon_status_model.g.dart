// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponStatusItem _$CouponStatusItemFromJson(Map<String, dynamic> json) =>
    CouponStatusItem(
      couponRuleId: json['couponRuleId'] as String,
      displayStatus: $enumDecode(_$DisplayStatusEnumMap, json['displayStatus']),
    );

Map<String, dynamic> _$CouponStatusItemToJson(CouponStatusItem instance) =>
    <String, dynamic>{
      'couponRuleId': instance.couponRuleId,
      'displayStatus': _$DisplayStatusEnumMap[instance.displayStatus]!,
    };

const _$DisplayStatusEnumMap = {
  DisplayStatus.normal: 'NORMAL',
  DisplayStatus.soldOut: 'SOLD_OUT',
  DisplayStatus.discontinued: 'discontinued',
};

CouponStatusListResponse _$CouponStatusListResponseFromJson(
  Map<String, dynamic> json,
) => CouponStatusListResponse(
  couponStatusList: (json['couponStatusList'] as List<dynamic>)
      .map((e) => CouponStatusItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CouponStatusListResponseToJson(
  CouponStatusListResponse instance,
) => <String, dynamic>{'couponStatusList': instance.couponStatusList};
