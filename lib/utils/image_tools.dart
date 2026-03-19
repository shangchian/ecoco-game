
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:path_provider/path_provider.dart';

class ImageTools {
  static Future<String> convertToBase64(File file) async {
    final bytes = await file.readAsBytes();
    String base64Image =  "data:image/jpeg;base64,${base64Encode(bytes)}";
    return base64Image;
  }

  static Future<List<int>> downloadImage(String avatarUrl) async {
    var tmpDir = await getTemporaryDirectory();
    var  cacheStore = FileCacheStore(tmpDir.path);

    var cacheOptions = CacheOptions(
      store: cacheStore,
      hitCacheOnErrorCodes: [],
    );

    final dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(options: cacheOptions),
    );

    final response = await dio.get(avatarUrl,
      options: Options(
        responseType: ResponseType.bytes
      )
    );
    return response.data;
  }
}