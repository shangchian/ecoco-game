import 'package:json_annotation/json_annotation.dart';

part 'area_district_model.g.dart';

@JsonSerializable()
class District {
  final String id;
  final String name;

  District({
    required this.id,
    required this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

@JsonSerializable()
class AreaDistrict {
  final String areaId;
  final String areaName;
  final List<District> districtList;

  AreaDistrict({
    required this.areaId,
    required this.areaName,
    required this.districtList,
  });

  factory AreaDistrict.fromJson(Map<String, dynamic> json) =>
      _$AreaDistrictFromJson(json);
  Map<String, dynamic> toJson() => _$AreaDistrictToJson(this);
}

@JsonSerializable()
class AreaDistrictResult {
  final List<AreaDistrict> all;
  final List<AreaDistrict> stationOnly;

  AreaDistrictResult({
    required this.all,
    required this.stationOnly,
  });

  factory AreaDistrictResult.fromJson(Map<String, dynamic> json) =>
      _$AreaDistrictResultFromJson(json);
  Map<String, dynamic> toJson() => _$AreaDistrictResultToJson(this);
}

@JsonSerializable()
class AreaDistrictResponse {
  final AreaDistrictResult result;

  AreaDistrictResponse({
    required this.result,
  });

  factory AreaDistrictResponse.fromJson(Map<String, dynamic> json) =>
      _$AreaDistrictResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AreaDistrictResponseToJson(this);
}

@JsonSerializable()
class AreaDistrictCache {
  final AreaDistrictResponse data;
  final String? etag;
  final String? lastModified;
  final DateTime cachedAt;

  AreaDistrictCache({
    required this.data,
    this.etag,
    this.lastModified,
    required this.cachedAt,
  });

  factory AreaDistrictCache.fromJson(Map<String, dynamic> json) =>
      _$AreaDistrictCacheFromJson(json);
  Map<String, dynamic> toJson() => _$AreaDistrictCacheToJson(this);
}
