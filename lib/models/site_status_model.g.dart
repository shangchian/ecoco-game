// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemStatus _$ItemStatusFromJson(Map<String, dynamic> json) => ItemStatus(
  itemCode: json['itemCode'] as String,
  status: json['status'] as String,
  linkedBinCode: json['linkedBinCode'] as String?,
);

Map<String, dynamic> _$ItemStatusToJson(ItemStatus instance) =>
    <String, dynamic>{
      'itemCode': instance.itemCode,
      'status': instance.status,
      'linkedBinCode': instance.linkedBinCode,
    };

BinStatus _$BinStatusFromJson(Map<String, dynamic> json) => BinStatus(
  binCode: json['binCode'] as String,
  availableCount: (json['availableCount'] as num).toInt(),
);

Map<String, dynamic> _$BinStatusToJson(BinStatus instance) => <String, dynamic>{
  'binCode': instance.binCode,
  'availableCount': instance.availableCount,
};

SiteStatus _$SiteStatusFromJson(Map<String, dynamic> json) => SiteStatus(
  siteId: json['siteId'] as String,
  displayStatus: json['displayStatus'] as String,
  cardType: json['cardType'] as String?,
  isOffHours: json['isOffHours'] as bool?,
  itemStatusList: (json['itemStatusList'] as List<dynamic>?)
      ?.map((e) => ItemStatus.fromJson(e as Map<String, dynamic>))
      .toList(),
  binStatusList: (json['binStatusList'] as List<dynamic>?)
      ?.map((e) => BinStatus.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SiteStatusToJson(SiteStatus instance) =>
    <String, dynamic>{
      'siteId': instance.siteId,
      'displayStatus': instance.displayStatus,
      'cardType': instance.cardType,
      'isOffHours': instance.isOffHours,
      'itemStatusList': instance.itemStatusList,
      'binStatusList': instance.binStatusList,
    };
