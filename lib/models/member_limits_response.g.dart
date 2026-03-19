// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_limits_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberLimitsResponse _$MemberLimitsResponseFromJson(
  Map<String, dynamic> json,
) => MemberLimitsResponse(
  couponRuleId: json['couponRuleId'] as String,
  isExchangeable: json['isExchangeable'] as bool,
  maxExchangeableUnits: (json['maxExchangeableUnits'] as num).toInt(),
  reasonMessage: json['reasonMessage'] as String?,
);

Map<String, dynamic> _$MemberLimitsResponseToJson(
  MemberLimitsResponse instance,
) => <String, dynamic>{
  'couponRuleId': instance.couponRuleId,
  'isExchangeable': instance.isExchangeable,
  'maxExchangeableUnits': instance.maxExchangeableUnits,
  'reasonMessage': instance.reasonMessage,
};
