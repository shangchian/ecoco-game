import 'dart:convert';
import 'package:flutter/services.dart';

import '/models/carousel_model.dart';
import '/services/interface/i_carousels_service.dart';

class CarouselsServiceMock implements ICarouselsService {
  // Cache for loaded data
  List<CarouselModel>? _cachedCarousels;

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<CarouselsResponse> fetchCarousels({
    String? etag,
    String? lastModified,
  }) async {
    await _simulateNetworkDelay();

    // Simulate 304 response if etag matches
    if (etag == 'mock-etag-carousels') {
      throw CacheNotModifiedException();
    }

    final carousels = await loadBundledCarousels();
    return CarouselsResponse(
      carousels: carousels,
      etag: 'mock-etag-carousels',
      lastModified: DateTime.now().toUtc().toIso8601String(),
    );
  }

  @override
  Future<List<CarouselModel>> loadBundledCarousels() async {
    if (_cachedCarousels != null) return _cachedCarousels!;

    final jsonString =
        await rootBundle.loadString('assets/data/carousels.json');
    final dynamic json = jsonDecode(jsonString);

    List<dynamic> carouselsList;
    if (json is List) {
      carouselsList = json;
    } else if (json is Map && json.containsKey('result')) {
      carouselsList = json['result'];
    } else {
      throw Exception('Unexpected format in bundled carousels.json');
    }

    _cachedCarousels =
        carouselsList.map((item) => CarouselModel.fromJson(item)).toList();
    return _cachedCarousels!;
  }
}
