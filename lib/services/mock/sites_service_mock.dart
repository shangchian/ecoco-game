import 'dart:convert';
import 'package:flutter/services.dart';

import '/models/site_model.dart';
import '/models/site_status_model.dart';
import '/services/interface/i_sites_service.dart';

class SitesServiceMock implements ISitesService {
  // Cache for loaded data
  List<Site>? _cachedSites;
  List<SiteStatus>? _cachedStatuses;

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<SitesResponse> fetchSites({String? etag, String? lastModified}) async {
    await _simulateNetworkDelay();

    // Simulate 304 response if etag matches
    if (etag == 'mock-etag-bundled') {
      throw CacheNotModifiedException();
    }

    final sites = await loadBundledSites();
    return SitesResponse(
      sites: sites,
      etag: 'mock-etag-bundled',
      lastModified: DateTime.now().toUtc().toIso8601String(),
    );
  }

  @override
  Future<List<SiteStatus>> fetchSiteStatuses({
    int? areaId,
    int? districtId,
  }) async {
    await _simulateNetworkDelay();

    // Load from bundled site-status.json
    if (_cachedStatuses == null) {
      final jsonString =
          await rootBundle.loadString('assets/data/site-status.json');
      final data = jsonDecode(jsonString);
      final List<dynamic> result = data['result'];
      _cachedStatuses =
          result.map((json) => SiteStatus.fromJson(json)).toList();
    }

    // Filter by areaId/districtId if provided
    var statuses = _cachedStatuses!;
    if (areaId != null || districtId != null) {
      final sites = await loadBundledSites();
      final siteIdsInArea = sites.where((site) {
        if (areaId != null && int.tryParse(site.areaId) != areaId) return false;
        if (districtId != null && int.tryParse(site.districtId) != districtId) {
          return false;
        }
        return true;
      }).map((s) => s.id).toSet();

      statuses =
          statuses.where((s) => siteIdsInArea.contains(s.siteId)).toList();
    }

    return statuses;
  }

  @override
  Future<List<Site>> loadBundledSites() async {
    if (_cachedSites != null) return _cachedSites!;

    final jsonString = await rootBundle.loadString('assets/data/sites.json');
    final dynamic json = jsonDecode(jsonString);

    List<dynamic> sitesList;
    if (json is List) {
      sitesList = json;
    } else if (json is Map && json.containsKey('result')) {
      sitesList = json['result'];
    } else {
      throw Exception('Unexpected format in bundled sites.json');
    }

    _cachedSites = sitesList.map((item) => Site.fromJson(item)).toList();
    return _cachedSites!;
  }
}
