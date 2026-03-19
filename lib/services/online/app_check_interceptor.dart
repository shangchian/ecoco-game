import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

/// Dio Interceptor to add Firebase AppCheck token to requests
class AppCheckInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get AppCheck token
      final appCheckToken = await FirebaseAppCheck.instance.getToken();

      if (appCheckToken != null) {
        // Add X-Firebase-AppCheck header
        options.headers['X-Firebase-AppCheck'] = appCheckToken;
        log('AppCheck token added to request: ${options.path}');
      } else {
        log('Warning: AppCheck token is null for request: ${options.path}');
      }
    } catch (e) {
      // Log error but don't block the request
      log('Error getting AppCheck token: $e');
    }

    // Continue with the request
    handler.next(options);
  }
}
