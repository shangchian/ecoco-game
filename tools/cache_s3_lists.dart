// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

/// Tool to fetch all S3 lists (sites, area/district, delete reasons, brands, coupon rules) and save to assets
/// Run with: dart run tools/cache_s3_lists.dart [environment]
/// Where environment is: develop (default) or production
void main(List<String> args) async {
  try {
    // Determine which environment to use (default: develop)
    final environment = args.isNotEmpty ? args[0] : 'develop';

    print('═══════════════════════════════════════════════════════');
    print('  Caching S3 Lists for Environment: $environment');
    print('═══════════════════════════════════════════════════════\n');

    // Define S3 URLs for all lists
    final Map<String, String> s3Urls = _getS3Urls(environment);

    print('Fetching from environment: $environment');
    print('  - Sites: ${s3Urls['sites']}');
    print('  - Area/District: ${s3Urls['areaDistrict']}');
    print('  - Delete Reasons: ${s3Urls['deleteReasons']}');
    print('  - Brands: ${s3Urls['brands']}');
    print('  - Coupon Rules: ${s3Urls['couponRules']}');
    print('  - Carousels: ${s3Urls['carousels']}');
    print('  - Notifications: ${s3Urls['notifications']}\n');

    // Ensure assets/data directory exists
    final directory = Directory('assets/data');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Fetch all lists in parallel
    final dio = Dio();
    final results = await Future.wait([
      _fetchSites(dio, s3Urls['sites']!, environment),
      _fetchAreaDistrict(dio, s3Urls['areaDistrict']!, environment),
      _fetchDeleteReasons(dio, s3Urls['deleteReasons']!, environment),
      _fetchBrands(dio, s3Urls['brands']!, environment),
      _fetchCouponRules(dio, s3Urls['couponRules']!, environment),
      _fetchCarousels(dio, s3Urls['carousels']!, environment),
      _fetchNotifications(dio, s3Urls['notifications']!, environment),
    ]);

    // Check if all succeeded
    if (results.every((r) => r)) {
      print('\n═══════════════════════════════════════════════════════');
      print('  ✓ All S3 lists cached successfully!');
      print('═══════════════════════════════════════════════════════');
      exit(0);
    } else {
      print('\n✗ Some lists failed to cache');
      exit(1);
    }
  } catch (e, stackTrace) {
    print('\n✗ Error caching S3 lists: $e');
    print(stackTrace);
    exit(1);
  }
}

/// Get S3 URLs for the specified environment
Map<String, String> _getS3Urls(String environment) {
  final baseUrl = environment == 'production'
      ? 'https://static.ecoco.xyz/production/app/share'
      : 'https://static.ecoco.xyz/develop/app/share';

  return {
    'sites': '$baseUrl/sites.json',
    'areaDistrict': '$baseUrl/area-district-list.json',
    'deleteReasons': '$baseUrl/member-delete-reasons.json',
    'brands': '$baseUrl/brands.json',
    'couponRules': '$baseUrl/coupon-rules.json',
    'carousels': '$baseUrl/carousels.json',
    'notifications': '$baseUrl/notifications.json',
  };
}

/// Fetch and cache sites list
Future<bool> _fetchSites(Dio dio, String url, String environment) async {
  try {
    print('[Sites] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    dynamic sitesData;
    if (response.data is Map && response.data.containsKey('result')) {
      sitesData = response.data;
    } else if (response.data is List) {
      sitesData = {'result': response.data};
    } else {
      throw Exception('Unexpected response format');
    }

    final siteCount = (sitesData['result'] as List).length;
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write sites data
    final file = File('assets/data/sites.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(sitesData),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/sites_metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'siteCount': siteCount,
      }),
      flush: true,
    );

    print('[Sites] ✓ Cached $siteCount sites (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Sites] ✗ Error: $e');
    return false;
  }
}

/// Fetch and cache area/district list
Future<bool> _fetchAreaDistrict(
    Dio dio, String url, String environment) async {
  try {
    print('[Area/District] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    if (response.data is! Map || !response.data.containsKey('result')) {
      throw Exception('Unexpected response format');
    }

    final data = response.data;
    final result = data['result'];
    final allCount = (result['all'] as List).length;
    final stationOnlyCount = (result['stationOnly'] as List).length;
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write area/district data
    final file = File('assets/data/area-district-list.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(data),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/area-district-metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'allAreasCount': allCount,
        'stationOnlyAreasCount': stationOnlyCount,
      }),
      flush: true,
    );

    print('[Area/District] ✓ Cached $allCount areas (all), $stationOnlyCount areas (stationOnly) (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Area/District] ✗ Error: $e');
    return false;
  }
}

/// Fetch and cache delete reasons list
Future<bool> _fetchDeleteReasons(
    Dio dio, String url, String environment) async {
  try {
    print('[Delete Reasons] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    if (response.data is! Map || !response.data.containsKey('result')) {
      throw Exception('Unexpected response format');
    }

    final data = response.data;
    final kindCount = (data['result'] as List).length;

    // Count total reasons
    int totalReasons = 0;
    for (var kind in data['result'] as List) {
      totalReasons += (kind['reasons'] as List).length;
    }

    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write delete reasons data
    final file = File('assets/data/member-delete-reasons.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(data),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/member-delete-reasons-metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'kindCount': kindCount,
        'totalReasons': totalReasons,
      }),
      flush: true,
    );

    print('[Delete Reasons] ✓ Cached $kindCount kinds, $totalReasons reasons (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Delete Reasons] ✗ Error: $e');
    return false;
  }
}

/// Fetch and cache brands list
Future<bool> _fetchBrands(Dio dio, String url, String environment) async {
  try {
    print('[Brands] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    dynamic brandsData;
    if (response.data is Map && response.data.containsKey('result')) {
      brandsData = response.data;
    } else if (response.data is List) {
      brandsData = {'result': response.data};
    } else {
      throw Exception('Unexpected response format');
    }

    final brandCount = (brandsData['result'] as List).length;
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write brands data
    final file = File('assets/data/brands.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(brandsData),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/brands_metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'brandCount': brandCount,
      }),
      flush: true,
    );

    print('[Brands] ✓ Cached $brandCount brands (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Brands] ✗ Error: $e');
    return false;
  }
}

/// Fetch and cache coupon rules list
Future<bool> _fetchCouponRules(Dio dio, String url, String environment) async {
  try {
    print('[Coupon Rules] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    dynamic couponRulesData;
    if (response.data is Map && response.data.containsKey('result')) {
      couponRulesData = response.data;
    } else if (response.data is List) {
      couponRulesData = {'result': response.data};
    } else {
      throw Exception('Unexpected response format');
    }

    final couponRuleCount = (couponRulesData['result'] as List).length;
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write coupon rules data
    final file = File('assets/data/coupon-rules.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(couponRulesData),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/coupon-rules-metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'couponRuleCount': couponRuleCount,
      }),
      flush: true,
    );

    print('[Coupon Rules] ✓ Cached $couponRuleCount coupon rules (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Coupon Rules] ✗ Error: $e');
    return false;
  }
}

/// Fetch and cache carousels list
Future<bool> _fetchCarousels(Dio dio, String url, String environment) async {
  try {
    print('[Carousels] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    dynamic carouselsData;
    if (response.data is Map && response.data.containsKey('result')) {
      carouselsData = response.data;
    } else if (response.data is List) {
      carouselsData = {'result': response.data};
    } else {
      throw Exception('Unexpected response format');
    }

    final carouselCount = (carouselsData['result'] as List).length;
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write carousels data
    final file = File('assets/data/carousels.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(carouselsData),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/carousels-metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'carouselCount': carouselCount,
      }),
      flush: true,
    );

    print('[Carousels] ✓ Cached $carouselCount carousels (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Carousels] ✗ Error: $e');
    return false;
  }
}

/// Fetch and cache notifications list
Future<bool> _fetchNotifications(
    Dio dio, String url, String environment) async {
  try {
    print('[Notifications] Fetching...');
    final response = await dio.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch: HTTP ${response.statusCode}');
    }

    // Parse the response
    if (response.data is! Map || !response.data.containsKey('result')) {
      throw Exception('Unexpected response format');
    }

    final data = response.data;
    final result = data['result'];
    final announcementsCount = (result['announcements'] as List?)?.length ?? 0;
    final campaignsCount = (result['campaigns'] as List?)?.length ?? 0;
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    // Write notifications data
    final file = File('assets/data/notifications.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(data),
      flush: true,
    );

    // Write metadata
    final metadataFile = File('assets/data/notifications-metadata.json');
    metadataFile.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'cachedAt': DateTime.now().toIso8601String(),
        'environment': environment,
        'etag': etag,
        'lastModified': lastModified,
        'announcementsCount': announcementsCount,
        'campaignsCount': campaignsCount,
      }),
      flush: true,
    );

    print('[Notifications] ✓ Cached $announcementsCount announcements, $campaignsCount campaigns (${(file.lengthSync() / 1024).toStringAsFixed(2)} KB)');
    return true;
  } catch (e) {
    print('[Notifications] ✗ Error: $e');
    return false;
  }
}
