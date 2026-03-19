// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Site _$SiteFromJson(Map<String, dynamic> json) => Site(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  type: json['type'] == null
      ? SiteType.groupedBin
      : const SiteTypeConverter().fromJson(json['type'] as String?),
  address: json['address'] as String,
  longitude: (json['longitude'] as num).toDouble(),
  latitude: (json['latitude'] as num).toDouble(),
  serviceHours: json['serviceHours'] as String,
  areaId: json['areaId'] as String,
  districtId: json['districtId'] as String,
  note: json['note'] as String?,
  recyclableItems: (json['recyclableItems'] as List<dynamic>)
      .map((e) => $enumDecode(_$RecyclableItemTypeEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$SiteToJson(Site instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'type': const SiteTypeConverter().toJson(instance.type),
  'address': instance.address,
  'longitude': instance.longitude,
  'latitude': instance.latitude,
  'serviceHours': instance.serviceHours,
  'areaId': instance.areaId,
  'districtId': instance.districtId,
  'note': instance.note,
  'recyclableItems': instance.recyclableItems
      .map((e) => _$RecyclableItemTypeEnumMap[e]!)
      .toList(),
};

const _$RecyclableItemTypeEnumMap = {
  RecyclableItemType.petBottle: 'PET_BOTTLE',
  RecyclableItemType.aluminumCan: 'ALUMINUM_CAN',
  RecyclableItemType.ppCup: 'PP_CUP',
  RecyclableItemType.hdpeBottle: 'HDPE_BOTTLE',
  RecyclableItemType.battery: 'BATTERY',
};
