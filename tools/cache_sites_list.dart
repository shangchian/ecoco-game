// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

/// Tool to fetch sites data from S3 and save to assets for bundling
/// Run with: dart run tools/cache_sites_list.dart [environment]
/// Where environment is: develop (default) or production
void main(List<String> args) async {
  try {
    // Determine which environment to use (default: develop)
    final environment = args.isNotEmpty ? args[0] : 'develop';

    String s3Url;
    switch (environment) {
      case 'production':
        s3Url = 'https://static.ecoco.xyz/production/app/share/sites.json';
        break;
      case 'develop':
      default:
        // 開會決議使用正式站的資訊，進行debug
        s3Url = 'https://static.ecoco.xyz/production/app/share/sites.json';
        //s3Url = 'https://static.ecoco.xyz/develop/app/share/sites.json';
        break;
    }

    print('Fetching sites from: $s3Url');

    // Fetch sites from S3
    final dio = Dio();
    final response = await dio.get(s3Url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch sites: HTTP ${response.statusCode}');
    }

    // Parse the response
    dynamic sitesData;
    if (response.data is Map && response.data.containsKey('result')) {
      // Handle format: { "result": [...] }
      sitesData = response.data;
    } else if (response.data is List) {
      // Handle format: [...]
      sitesData = {'result': response.data};
    } else {
      throw Exception('Unexpected response format');
    }

    print('Fetched ${(sitesData['result'] as List).length} sites');

    // Extract ETag and Last-Modified headers for reference
    final etag = response.headers.value('etag');
    final lastModified = response.headers.value('last-modified');

    if (etag != null) {
      print('ETag: $etag');
    }
    if (lastModified != null) {
      print('Last-Modified: $lastModified');
    }

    // Ensure assets/data directory exists
    final directory = Directory('assets/data');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Write sites data to assets/data/sites.json
    final file = File('assets/data/sites.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert(sitesData),
      flush: true,
    );

    print('✓ Sites data cached successfully to assets/data/sites.json');
    print('  File size: ${(file.lengthSync() / 1024).toStringAsFixed(2)} KB');

    // Optionally save metadata to a separate file for reference
    if (etag != null || lastModified != null) {
      final metadataFile = File('assets/data/sites_metadata.json');
      metadataFile.writeAsStringSync(
        JsonEncoder.withIndent('  ').convert({
          'cachedAt': DateTime.now().toIso8601String(),
          'environment': environment,
          'etag': etag,
          'lastModified': lastModified,
          'siteCount': (sitesData['result'] as List).length,
        }),
        flush: true,
      );
      print('✓ Metadata saved to assets/data/sites_metadata.json');
    }

    exit(0);
  } catch (e, stackTrace) {
    print('✗ Error caching sites data: $e');
    print(stackTrace);
    exit(1);
  }
}
