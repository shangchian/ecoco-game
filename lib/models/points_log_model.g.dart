// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailItem _$DetailItemFromJson(Map<String, dynamic> json) => DetailItem(
  name: json['name'] as String,
  quantity: (json['quantity'] as num?)?.toInt(),
  points: (json['points'] as num).toInt(),
);

Map<String, dynamic> _$DetailItemToJson(DetailItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'points': instance.points,
    };

PointLog _$PointLogFromJson(Map<String, dynamic> json) => PointLog(
  logId: json['logId'] as String,
  logType: $enumDecode(_$LogTypeEnumMap, json['logType']),
  iconTypeCode: $enumDecode(_$IconTypeCodeEnumMap, json['iconTypeCode']),
  currencyCode: json['currencyCode'] as String,
  title: json['title'] as String? ?? '',
  labelText: json['labelText'] as String?,
  labelColor: json['labelColor'] as String?,
  pointsChange: (json['pointsChange'] as num).toInt(),
  occurredAt: json['occurredAt'] as String,
  detailType: $enumDecode(_$DetailTypeEnumMap, json['detailType']),
  detailsRaw: json['details'] as Map<String, dynamic>?,
  lastUpdatedAt: json['lastUpdatedAt'] as String,
);

Map<String, dynamic> _$PointLogToJson(PointLog instance) => <String, dynamic>{
  'logId': instance.logId,
  'logType': _$LogTypeEnumMap[instance.logType]!,
  'iconTypeCode': _$IconTypeCodeEnumMap[instance.iconTypeCode]!,
  'currencyCode': instance.currencyCode,
  'title': instance.title,
  'labelText': instance.labelText,
  'labelColor': instance.labelColor,
  'pointsChange': instance.pointsChange,
  'occurredAt': instance.occurredAt,
  'detailType': _$DetailTypeEnumMap[instance.detailType]!,
  'details': instance.detailsRaw,
  'lastUpdatedAt': instance.lastUpdatedAt,
};

const _$LogTypeEnumMap = {LogType.earned: 'EARNED', LogType.used: 'USED'};

const _$IconTypeCodeEnumMap = {
  IconTypeCode.bottle: 'BOTTLE',
  IconTypeCode.battery: 'BATTERY',
  IconTypeCode.specialToken: 'SPECIAL_TOKEN',
  IconTypeCode.fbc: 'FBC',
  IconTypeCode.systemAdd: 'SYSTEM_ADD',
  IconTypeCode.systemDeduct: 'SYSTEM_DEDUCT',
  IconTypeCode.couponRedeem: 'COUPON_REDEEM',
  IconTypeCode.couponRefund: 'COUPON_REFUND',
  IconTypeCode.codeRedeem: 'CODE_REDEEM',
  IconTypeCode.campaign: 'CAMPAIGN',
  IconTypeCode.pointsExchangeIn: 'POINTS_EXCHANGE_IN',
  IconTypeCode.pointsExchangeOut: 'POINTS_EXCHANGE_OUT',
};

const _$DetailTypeEnumMap = {
  DetailType.detailedList: 'DETAILED_LIST',
  DetailType.textDescription: 'TEXT_DESCRIPTION',
  DetailType.none: 'NONE',
};

PointsHistoryResponse _$PointsHistoryResponseFromJson(
  Map<String, dynamic> json,
) => PointsHistoryResponse(
  pointLogs: (json['pointLogs'] as List<dynamic>)
      .map((e) => PointLog.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PointsHistoryResponseToJson(
  PointsHistoryResponse instance,
) => <String, dynamic>{'pointLogs': instance.pointLogs};
