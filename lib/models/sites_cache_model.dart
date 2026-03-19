import 'package:json_annotation/json_annotation.dart';
import '/models/site_model.dart';

part 'sites_cache_model.g.dart';

@JsonSerializable(includeIfNull: true)
class SitesCache {
  final List<Site> sites;
  final String? etag;
  final String? lastModified;
  final DateTime cachedAt;

  const SitesCache({
    required this.sites,
    this.etag,
    this.lastModified,
    required this.cachedAt,
  });

  factory SitesCache.fromJson(Map<String, dynamic> json) =>
      _$SitesCacheFromJson(json);

  Map<String, dynamic> toJson() => _$SitesCacheToJson(this);
}
