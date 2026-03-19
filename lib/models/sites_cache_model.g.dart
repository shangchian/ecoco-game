// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sites_cache_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitesCache _$SitesCacheFromJson(Map<String, dynamic> json) => SitesCache(
  sites: (json['sites'] as List<dynamic>)
      .map((e) => Site.fromJson(e as Map<String, dynamic>))
      .toList(),
  etag: json['etag'] as String?,
  lastModified: json['lastModified'] as String?,
  cachedAt: DateTime.parse(json['cachedAt'] as String),
);

Map<String, dynamic> _$SitesCacheToJson(SitesCache instance) =>
    <String, dynamic>{
      'sites': instance.sites,
      'etag': instance.etag,
      'lastModified': instance.lastModified,
      'cachedAt': instance.cachedAt.toIso8601String(),
    };
