import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/auth_data_model.dart';
import '/utils/json_parsing_utils.dart';
import '/utils/token_validator.dart';
import '/utils/token_refresh_coordinator.dart';

/// Callback function type for notifying when tokens are refreshed
typedef OnTokenRefreshed = void Function(AuthData authData);

/// Callback function type for notifying when token refresh fails
typedef OnRefreshFailed = void Function(String? reason);

class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  OnTokenRefreshed? onTokenRefreshed;
  OnRefreshFailed? onRefreshFailed;

  TokenRefreshInterceptor(
    this._dio, {
    this.onTokenRefreshed,
    this.onRefreshFailed,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 排除不需要 token 的端點
    final path = options.path;
    if (path.contains('/auth/login') || 
        path.contains('/auth/send-otp') || 
        path.contains('/auth/verify-otp') ||
        path.contains('/auth/refresh-token')) {
      return handler.next(options);
    }

    // 從 SharedPreferences 取得最新的 authData
    try {
      final prefs = await SharedPreferences.getInstance();
      final authDataString = prefs.getString('authData');
      
      if (authDataString != null) {
        final authData = AuthData.fromJson(jsonDecode(authDataString));
        
        // 檢查 token 是否即將過期，提前刷新
        // 使用 TokenValidator.needsRefresh 檢查
        if (TokenValidator.needsRefresh(authData.accessTokenExpiresAt)) {
          try {
            final newAuthData = await _refreshToken();
            options.headers['Authorization'] = 'Bearer ${newAuthData.accessToken}';
          } catch (e) {
            // 如果刷新失敗，仍然使用舊的 token 嘗試
            // 讓 onError 處理後續的錯誤
            if (authData.accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer ${authData.accessToken}';
            }
          }
        } else if (authData.accessToken.isNotEmpty) {
          // Token 還有效，直接使用
          options.headers['Authorization'] = 'Bearer ${authData.accessToken}';
        }
      }
    } catch (e) {
      // 如果讀取失敗，不設定 header，讓請求繼續
      // 後續的錯誤處理會處理這個情況
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Check if response indicates token expiration
    if (_isTokenExpired(response)) {
      try {
        // Refresh the token
        final newAuthData = await _refreshToken();

        // Retry the original request with new token
        final retryResponse = await _retryRequest(response.requestOptions, newAuthData);
        
        // If retry still fails with 401, trigger logout
        if (retryResponse.statusCode == 401) {
          onRefreshFailed?.call('登入憑證失效 (401)');
        }
        
        return handler.resolve(retryResponse);
      } catch (e) {
        // If refresh fails, check if we should trigger logout
        final shouldLogout = _shouldLogoutOnError(e);
        
        if (shouldLogout) {
          final reason = _getLogoutReason(e);
          onRefreshFailed?.call(reason);
        }

        // Pass the error through
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: 'Token refresh failed on TokenRefreshInterceptor.onResponse: $e',
            type: DioExceptionType.unknown,
          ),
        );
      }
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check for 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      // Exclude auth endpoints to prevent interfering with login failures
      if (!path.contains('/auth/login') && !path.contains('/auth/verify-otp') && !path.contains('/auth/logout')) {
        try {
          // Refresh the token
          final newAuthData = await _refreshToken();

          // Retry the original request with new token
          final retryResponse = await _retryRequest(err.requestOptions, newAuthData);
          return handler.resolve(retryResponse);
        } catch (e) {
          // If refresh fails, check if we should trigger logout
          final shouldLogout = _shouldLogoutOnError(e);
          
          if (shouldLogout) {
            final reason = _getLogoutReason(e);
            onRefreshFailed?.call(reason);
          }

          // Pass the original error through
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  bool _isTokenExpired(Response response) {
    // Check for token expiration based on API response
    // Code 99001 indicates token expired according to API spec
    if (response.data is Map) {
      final int code = parseResponseCode(response.data);
      if (code == 99001) return true;
    }

    // Check for 401 Unauthorized (standard HTTP status)
    if (response.statusCode == 401) {
      final path = response.requestOptions.path;
      // Exclude auth endpoints to prevent interfering with login failures
      if (!path.contains('/auth/login') && !path.contains('/auth/verify-otp') && !path.contains('/auth/logout')) {
        return true;
      }
    }

    return false;
  }

  Future<AuthData> _refreshToken() async {
    // Synchronize using TokenRefreshCoordinator
    final coordinator = TokenRefreshCoordinator();
    
    // Check if a refresh is already in progress
    final existingRefresh = coordinator.preRefreshCheck();
    if (existingRefresh != null) {
      // Wait for the ongoing refresh to complete
      try {
        return await existingRefresh;
      } catch (e) {
        throw Exception('Concurrent token refresh failed: $e');
      }
    }

    try {
      // Get current auth data
      final prefs = await SharedPreferences.getInstance();
      final authDataString = prefs.getString('authData');

      if (authDataString == null) {
        throw Exception('No auth data found');
      }

      final authData = AuthData.fromJson(jsonDecode(authDataString));

      if (authData.refreshToken.isEmpty) {
        throw Exception('No refresh token available');
      }

      // Call refresh token endpoint directly (to avoid circular dependency)
      // 使用與 AuthRepository 相同的 dioWithAppCheck 機制（如果需要），但這裡為了簡單保持獨立 Dio
      final response = await _dio.post(
        '/auth/refresh-token',
        data: {'refreshToken': authData.refreshToken},
      );

      if (response.statusCode != 200) {
        String msg = 'Unknown error';
        if (response.data is Map && response.data['message'] != null) {
          msg = response.data['message'].toString();
        } else if (response.data is String) {
          msg = response.data;
        }
        throw Exception('Token refresh failed on TokenRefreshInterceptor.reFreshToken (Status ${response.statusCode}): $msg');
      }
      
      if (parseResponseCode(response.data) != 0) {
        String msg = 'Unknown error';
        if (response.data is Map && response.data['message'] != null) {
          msg = response.data['message'].toString();
        }
        throw Exception('Token refresh failed on TokenRefreshInterceptor.reFreshToken: $msg');
      }

      // Parse and save new auth data
      final newAuthData = AuthData.fromJson(response.data['result']);
      await prefs.setString('authData', jsonEncode(newAuthData.toJson()));

      // Notify callback if provided
      onTokenRefreshed?.call(newAuthData);

      // Notify coordinator of success
      coordinator.onSuccess(newAuthData);

      return newAuthData;
    } catch (e) {
      // Notify coordinator of failure
      coordinator.onError(e);
      rethrow;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions, AuthData authData) async {
    // Update token in request data if it exists
    if (requestOptions.data is Map) {
      final data = Map<String, dynamic>.from(requestOptions.data);
      if (data.containsKey('token')) {
        data['token'] = authData.accessToken;
        requestOptions.data = data;
      }
    }

    // 無論原本是否有 Authorization header，都設定新的 token
    requestOptions.headers['Authorization'] = 'Bearer ${authData.accessToken}';

    // Retry the request
    return await _dio.fetch(requestOptions);
  }

  /// 判斷是否應該因為此錯誤而執行登出
  ///
  /// 只有明確的 Auth 錯誤 (401, 403, 特定 error code) 才登出
  /// 網路連線問題 (Timeout, Connection Error) 應保留登入狀態
  bool _shouldLogoutOnError(dynamic error) {
    if (error is DioException) {
      // 網路連線層級的錯誤 -> 不登出
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return false;
      }
      
      // Server 回傳錯誤
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        // 401 Unauthorized, 403 Forbidden -> 登出
        if (statusCode == 401 || statusCode == 403) {
          return true;
        }

        // 檢查 API Error Code (如果是 Map)
        if (error.response!.data is Map) {
          final int code = parseResponseCode(error.response!.data);
           // 99001: Token Expired, 10002: Unauthorized
          if (code == 99001 || code == 10002) {
            return true;
          }
        }
      }
    }
    
    // 如果是我們自己拋出的 Exception (例如在 _refreshToken 中檢查到的 code != 0)
    if (error is Exception) {
      final msg = error.toString();
      // 檢查關鍵字
      if (msg.contains('Unauthorized') || 
          msg.contains('Token expired') ||
          msg.contains('refresh failed') || 
          msg.contains('No refresh token')) {
            return true;
      }
    }

    // 預設行為：如果無法判定是網路錯誤，為了安全起見，或是為了避免無限迴圈
    // 但為了改善使用者體驗，對於未知錯誤選擇 "不登出"，除非確定是 Auth 失敗
    // 這樣可以避免 Server 500 錯誤導致登出
    return false;
  }

  String _getLogoutReason(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        return '登入憑證失效 ($statusCode)';
      }
      return '與伺服器連線失敗';
    }
    
    if (error is Exception) {
      final msg = error.toString();
      // 嘗試從 Exception 訊息中提取 Status Code 與 Message
      // _refreshToken 拋出的格式: 
      // "Exception: Token refresh failed on TokenRefreshInterceptor.reFreshToken (Status 400): 錯誤詳細訊息"
      
      // 提取 Status Code
      final codeRegex = RegExp(r'\(Status (\d+)\)');
      final codeMatch = codeRegex.firstMatch(msg);
      final statusCode = codeMatch?.group(1) ?? '';

      // 提取冒號後的詳細訊息
      if (msg.contains('): ')) {
        final parts = msg.split('): ');
        if (parts.length > 1) {
          final detailMsg = parts.last.trim();
          return '登入憑證失效 ($statusCode)\n$detailMsg';
        }
      }
      
      if (statusCode.isNotEmpty) {
         return '登入憑證失效 ($statusCode)';
      }
      
      if (msg.contains('No refresh token')) {
        return '登入憑證遺失';
      }
    }

    // 簡化錯誤訊息
    return '登入憑證已過期'; 
  }
}
