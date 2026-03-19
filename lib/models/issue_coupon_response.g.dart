// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueCouponResponse _$IssueCouponResponseFromJson(Map<String, dynamic> json) =>
    IssueCouponResponse(
      couponRuleId: json['couponRuleId'] as String,
      exchangeUnits: (json['exchangeUnits'] as num).toInt(),
      totalCost: (json['totalCost'] as num).toInt(),
      issuedCount: (json['issuedCount'] as num).toInt(),
      issuedMemberCouponIds: (json['issuedMemberCouponIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IssueCouponResponseToJson(
  IssueCouponResponse instance,
) => <String, dynamic>{
  'couponRuleId': instance.couponRuleId,
  'exchangeUnits': instance.exchangeUnits,
  'totalCost': instance.totalCost,
  'issuedCount': instance.issuedCount,
  'issuedMemberCouponIds': instance.issuedMemberCouponIds,
};
