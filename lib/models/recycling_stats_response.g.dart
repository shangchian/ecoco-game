// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycling_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecyclingStatsResponse _$RecyclingStatsResponseFromJson(
  Map<String, dynamic> json,
) => RecyclingStatsResponse(
  carbonMetrics: CarbonMetrics.fromJson(
    json['carbonMetrics'] as Map<String, dynamic>,
  ),
  itemList: (json['itemList'] as List<dynamic>)
      .map((e) => RecyclingItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecyclingStatsResponseToJson(
  RecyclingStatsResponse instance,
) => <String, dynamic>{
  'carbonMetrics': instance.carbonMetrics,
  'itemList': instance.itemList,
};

CarbonMetrics _$CarbonMetricsFromJson(Map<String, dynamic> json) =>
    CarbonMetrics(
      totalCarbonReduction: const DoubleConverter().fromJson(
        json['totalCarbonReduction'],
      ),
      monthlyCarbonReduction: const DoubleConverter().fromJson(
        json['monthlyCarbonReduction'],
      ),
      annualCarbonReduction: const DoubleConverter().fromJson(
        json['annualCarbonReduction'],
      ),
    );

Map<String, dynamic> _$CarbonMetricsToJson(CarbonMetrics instance) =>
    <String, dynamic>{
      'totalCarbonReduction': const DoubleConverter().toJson(
        instance.totalCarbonReduction,
      ),
      'monthlyCarbonReduction': const DoubleConverter().toJson(
        instance.monthlyCarbonReduction,
      ),
      'annualCarbonReduction': const DoubleConverter().toJson(
        instance.annualCarbonReduction,
      ),
    };

RecyclingItem _$RecyclingItemFromJson(Map<String, dynamic> json) =>
    RecyclingItem(
      itemCode: json['itemCode'] as String,
      itemName: json['itemName'] as String,
      totalCount: const IntConverter().fromJson(json['totalCount']),
      countThisYear: const IntConverter().fromJson(json['countThisYear']),
      countThisMonth: const IntConverter().fromJson(json['countThisMonth']),
    );

Map<String, dynamic> _$RecyclingItemToJson(RecyclingItem instance) =>
    <String, dynamic>{
      'itemCode': instance.itemCode,
      'itemName': instance.itemName,
      'totalCount': const IntConverter().toJson(instance.totalCount),
      'countThisYear': _$JsonConverterToJson<dynamic, int>(
        instance.countThisYear,
        const IntConverter().toJson,
      ),
      'countThisMonth': _$JsonConverterToJson<dynamic, int>(
        instance.countThisMonth,
        const IntConverter().toJson,
      ),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
