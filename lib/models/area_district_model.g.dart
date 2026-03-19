// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_district_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

District _$DistrictFromJson(Map<String, dynamic> json) =>
    District(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

AreaDistrict _$AreaDistrictFromJson(Map<String, dynamic> json) => AreaDistrict(
  areaId: json['areaId'] as String,
  areaName: json['areaName'] as String,
  districtList: (json['districtList'] as List<dynamic>)
      .map((e) => District.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AreaDistrictToJson(AreaDistrict instance) =>
    <String, dynamic>{
      'areaId': instance.areaId,
      'areaName': instance.areaName,
      'districtList': instance.districtList,
    };

AreaDistrictResult _$AreaDistrictResultFromJson(Map<String, dynamic> json) =>
    AreaDistrictResult(
      all: (json['all'] as List<dynamic>)
          .map((e) => AreaDistrict.fromJson(e as Map<String, dynamic>))
          .toList(),
      stationOnly: (json['stationOnly'] as List<dynamic>)
          .map((e) => AreaDistrict.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AreaDistrictResultToJson(AreaDistrictResult instance) =>
    <String, dynamic>{'all': instance.all, 'stationOnly': instance.stationOnly};

AreaDistrictResponse _$AreaDistrictResponseFromJson(
  Map<String, dynamic> json,
) => AreaDistrictResponse(
  result: AreaDistrictResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AreaDistrictResponseToJson(
  AreaDistrictResponse instance,
) => <String, dynamic>{'result': instance.result};

AreaDistrictCache _$AreaDistrictCacheFromJson(Map<String, dynamic> json) =>
    AreaDistrictCache(
      data: AreaDistrictResponse.fromJson(json['data'] as Map<String, dynamic>),
      etag: json['etag'] as String?,
      lastModified: json['lastModified'] as String?,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );

Map<String, dynamic> _$AreaDistrictCacheToJson(AreaDistrictCache instance) =>
    <String, dynamic>{
      'data': instance.data,
      'etag': instance.etag,
      'lastModified': instance.lastModified,
      'cachedAt': instance.cachedAt.toIso8601String(),
    };
