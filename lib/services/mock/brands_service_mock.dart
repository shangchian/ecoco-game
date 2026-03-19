import 'dart:convert';
import 'package:flutter/services.dart';

import '/models/brand_model.dart';
import '/services/interface/i_brands_service.dart';

class BrandsServiceMock implements IBrandsService {
  // Cache for loaded data
  List<Brand>? _cachedBrands;

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<BrandsResponse> fetchBrands({String? etag, String? lastModified}) async {
    await _simulateNetworkDelay();

    // Simulate 304 response if etag matches
    if (etag == 'mock-etag-brands') {
      throw CacheNotModifiedException();
    }

    final brands = await loadBundledBrands();
    return BrandsResponse(
      brands: brands,
      etag: 'mock-etag-brands',
      lastModified: DateTime.now().toUtc().toIso8601String(),
    );
  }

  @override
  Future<List<Brand>> loadBundledBrands() async {
    if (_cachedBrands != null) return _cachedBrands!;

    final jsonString = await rootBundle.loadString('assets/data/brands.json');
    final dynamic json = jsonDecode(jsonString);

    List<dynamic> brandsList;
    if (json is List) {
      brandsList = json;
    } else if (json is Map && json.containsKey('result')) {
      brandsList = json['result'];
    } else {
      throw Exception('Unexpected format in bundled brands.json');
    }

    _cachedBrands = brandsList.map((item) => Brand.fromJson(item)).toList();
    return _cachedBrands!;
  }
}
