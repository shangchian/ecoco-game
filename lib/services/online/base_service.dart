import 'dart:io';

import 'package:dio/dio.dart';
import '../../flavors.dart';
import '../../utils/json_parsing_utils.dart';
import 'app_check_interceptor.dart';
import 'token_refresh_interceptor.dart';
import 'debug_logging_interceptor.dart';

/// Custom exception for API errors that includes error code from server response
class ApiException implements Exception {
  final int? code;
  final String message;

  ApiException(this.code, this.message);

  @override
  String toString() => message;
}

class BaseService {
  // Use flavor-based API URL
  // - mock: empty (not used)
  // - internal: https://api.funleadchange.com/app
  // - production: https://api.ecocogroup.com/app
  static String get baseUrl => F.apiBaseUrl;

  final Dio _dio;
  final Dio _dioWithAppCheck;

  BaseService({
    OnTokenRefreshed? onTokenRefreshed,
    OnRefreshFailed? onRefreshFailed,
  })  : _dio = Dio(BaseOptions(
            baseUrl: baseUrl,
            validateStatus: (status) => status != null,// && status <= 500,
            headers: {
            })),
        _dioWithAppCheck = Dio(BaseOptions(
          baseUrl: baseUrl,
          validateStatus: (status) => status != null,// && status <= 500,
          headers: {
          },
        ))..interceptors.add(AppCheckInterceptor()) {
    // Create a separate Dio instance for token refresh to avoid circular dependency
    final refreshDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => status != null,// && status < 500,
    ));

    // Add token refresh interceptor to main dio instances with callbacks
    _dio.interceptors.add(TokenRefreshInterceptor(
      refreshDio,
      onTokenRefreshed: onTokenRefreshed,
      onRefreshFailed: onRefreshFailed,
    ));
    _dioWithAppCheck.interceptors.add(TokenRefreshInterceptor(
      refreshDio,
      onTokenRefreshed: onTokenRefreshed,
      onRefreshFailed: onRefreshFailed,
    ));

    // Add debug logging interceptor only for internal flavor
    if (F.appFlavor == Flavor.internal) {
      _dio.interceptors.add(DebugLoggingInterceptor());
    }
  }

  Dio get dio => _dio;

  /// Use this dio instance for requests that require AppCheck (e.g., login)
  Dio get dioWithAppCheck => _dioWithAppCheck;

  void validateResponse(Response response) {
    if (response.statusCode == 200) {
      return;
    }

    // Throw ApiException with error code for better error handling downstream
    final dynamic data = response.data;
    
    // Try to find code in data, otherwise use statusCode
    int? errorCode = response.statusCode;
    
    final int parsedCode = parseResponseCode(data);
    if (parsedCode != -1) {
      errorCode = parsedCode;
    }

    // Try to find message in data
    String detailedMsg = "";
    if (data is Map) {
      detailedMsg = data['message']?.toString() ?? "";
    } else if (data is String) {
      detailedMsg = data;
    }

    final String errorMessage = "[${response.statusMessage ?? "Unknown error"}] $detailedMsg";
    throw ApiException(errorCode, errorMessage);
  }

  Exception handleError(dynamic error) {
    // Preserve JsonParsingException with detailed context
    if (error is JsonParsingException) {
      return error;
    }
    // IMPORTANT: Preserve ApiException so error codes can be used downstream
    if (error is ApiException) {
      return error;
    }
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('連線逾時，請檢查網路設定');
        case DioExceptionType.connectionError:
          return Exception('網路連線異常，請檢查網路設定');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            // 401/403 - Auth error (handled by interceptor but good to have clear message)
            if (statusCode == 401 || statusCode == 403) {
              return ApiException(statusCode, '登入憑證失效');
            }
            // 400 - Bad Request
            if (statusCode == 400) {
              // Try to get a more specific message if available, otherwise default
              String msg = '請求參數錯誤';
              if (error.response?.data is Map && error.response?.data['message'] != null) {
                 msg = error.response?.data['message'].toString() ?? msg;
              }
              return Exception(msg);
            }
            // 404 - Not Found
            if (statusCode == 404) {
              return Exception('找不到請求的資源');
            }
            // 500+ - Server Error
            if (statusCode >= 500) {
              return Exception('伺服器內部錯誤');
            }
            // Other status codes - try to parse backend message
            if (error.response?.data != null) {
              final parsedCode = parseResponseCode(error.response?.data);
              String detailedMsg = "";
              if (error.response?.data is Map) {
                detailedMsg = error.response?.data['message']?.toString() ?? "";
              } else if (error.response?.data is String) {
                detailedMsg = error.response?.data;
              }
              if (detailedMsg.isNotEmpty) {
                 return ApiException(parsedCode != -1 ? parsedCode : statusCode, detailedMsg);
              }
            }
          }
          return Exception('伺服器回應錯誤');
        case DioExceptionType.cancel:
          return Exception('請求已取消');
        default:
          return Exception('發生未知的錯誤');
      }
    }
    if (error is FormatException) {
      return Exception('資料格式錯誤');
    }
    if (error is HttpException) {
      return Exception('網路連線錯誤');
    }
    return error is Exception ? error : Exception(error.toString());
  }
}
