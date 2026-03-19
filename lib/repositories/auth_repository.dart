import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '/models/auth_data_model.dart';
import '/models/send_otp_response_model.dart';
import '/models/verify_otp_response_model.dart';
import '/models/verify_otp_reset_response_model.dart';
import '/models/profile_data_model.dart';
import '/models/otp_rate_limit_data.dart';
import '/services/interface/i_members_service.dart';
import '../services/online/members_service.dart';
import '/services/mock/members_service_mock.dart';
import '/services/firebase_messaging_service.dart';
import '/utils/image_tools.dart';
import '/utils/device_info_helper.dart';
import '/utils/timezone_helper.dart';
import '/flavors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '/services/online/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wallet_repository.dart';

/// API error code constants
class ApiErrorCodes {
  static const int invalidCredentials = 10002; // 帳號密碼不匹配
  static const int accountBlocked = 10004; // 帳號被鎖定
  static const int rateLimitExceeded = 99005; // 操作過於頻繁

  // OTP-related error codes
  static const int phoneAlreadyRegistered = 10001; // 手機號碼已註冊
  static const int accountNotRegistered = 10003; // 此帳號未註冊
  static const int otpExpired = 10005; // OTP已過期
  static const int otpIncorrect = 10006; // OTP輸入錯誤
  static const int sendOtpRateLimitExceeded = 10007; // 30分鐘內發送次數超限
  static const int smsSendFailure = 10008; // 簡訊發送失敗
  static const int registrationIncomplete = 10009; // 註冊尚未完成
}

enum AuthErrorCode {
  invalidCredentials,
  networkError,
  serverError,
  unauthorized,
  unknown,
  noData,
  unSupported,
}

class AuthenticationException implements Exception {
  final AuthErrorCode code;
  final String message;

  AuthenticationException(this.code, this.message);

  @override
  String toString() => message;
}

/// OTP 每日發送次數限制異常
class OtpRateLimitException implements Exception {
  final String purpose; // 'REGISTER' 或 'FORGOT_PASSWORD'
  final int limit;
  final int used;

  OtpRateLimitException({
    required this.purpose,
    required this.limit,
    required this.used,
  });

  @override
  String toString() {
    if (purpose == 'REGISTER') {
      return '您已發送 $used 次註冊驗證碼，已達上限 $limit 次。\n請於 60 分鐘後再重試。';
    } else {
      return '您已發送 $used 次密碼重設驗證碼，已達上限 $limit 次。\n請於 60 分鐘後再重試。';
    }
  }
}

class AuthRepository {
  static const String authDataKey = 'authData';

  // OTP Rate Limiting
  static const String otpRateLimitRegistrationKey = 'otpRateLimitRegistration';
  static const String otpRateLimitPasswordResetKey = 'otpRateLimitPasswordReset';
  static const int dailyOtpLimit = 5;

  final IMembersService _membersService;

  AuthRepository({IMembersService? membersService})
      : _membersService = membersService ??
      (F.useMockService ? MembersServiceMock() : MembersService());

  // Authentication
  Future<AuthData?> getLoggedInData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? authDataString = prefs.getString(
          AuthRepository.authDataKey);

      if (authDataString == null) return null;

      final decodedData = jsonDecode(authDataString);
      if (decodedData is! Map<String, dynamic>) {
        throw FormatException('Invalid stored auth data format');
      }

      final authData = AuthData.fromJson(decodedData);
      
      final String tmpMemberId = authData.memberId.toString();
      final String userId = F.appFlavor == Flavor.internal
          ? 'internal-$tmpMemberId'
          : tmpMemberId;
      await FirebaseAnalytics.instance.setUserId(id: userId);
      await FirebaseAnalytics.instance.setDefaultEventParameters({'member_id': userId});

      return authData;
    } catch (e) {
      // Log
      log('Error getting logged in data: $e');
      return null;
    }
  }

  Future<AuthData> login(String username, String password) async {
    try {
      // Get device information
      final deviceInfo = await DeviceInfoHelper.getDeviceInfo();

      // Try to get FCM token, return null if it fails
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        log('FCM Token: $fcmToken');
      } catch (e) {
        log('Failed to get FCM token: $e');
        fcmToken = null;
      }

      // Call login API with all required information
      final authData = await _membersService.login(
        username,
        password,
        fcmToken: fcmToken,
        deviceId: deviceInfo['deviceId']!,
        platform: deviceInfo['platform']!,
        deviceModel: deviceInfo['deviceModel']!,
        osVersion: deviceInfo['osVersion']!,
      );

      // Store auth data and set user ID for analytics (skip TEMPORARY to prevent auto-login)
      if (authData.memberStatus != 'TEMPORARY') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            AuthRepository.authDataKey, jsonEncode(authData.toJson()));
      }
      final String tmpMemberId = authData.memberId.toString();
      final String userId = F.appFlavor == Flavor.internal
          ? 'internal-$tmpMemberId'
          : tmpMemberId;
      await FirebaseAnalytics.instance.setUserId(id: userId);
      await FirebaseAnalytics.instance.setDefaultEventParameters({'member_id': userId});

      return authData;
    } on ApiException catch (e) {
      // Map API error codes to AuthenticationException
      switch (e.code) {
        case ApiErrorCodes.invalidCredentials:
          throw AuthenticationException(
            AuthErrorCode.invalidCredentials,
            e.message,
          );
        case ApiErrorCodes.accountBlocked:
          throw AuthenticationException(
            AuthErrorCode.unauthorized,
            e.message,
          );
        case ApiErrorCodes.rateLimitExceeded:
          throw AuthenticationException(
            AuthErrorCode.serverError,
            e.message,
          );
        default:
          throw AuthenticationException(
            AuthErrorCode.unknown,
            e.message,
          );
      }
    } catch (e) {
      // Handle other exceptions
      rethrow;
    }
  }

  Future<ProfileData> getInfo() async {
    final profileData = await _membersService.getProfile();
    // Don't save profile data to authDataKey anymore as they are separate
    // We might want to cache it separately, but for now just return it
    return profileData;
  }

  Future<void> logout(AuthData authData) async {
    await FirebaseAnalytics.instance.setUserId(id: null);
    await FirebaseAnalytics.instance.setDefaultEventParameters({'member_id': null});
    try {
      await _membersService.logout();
    } catch (e) {
      log('Logout API call failed: $e');
    }

    await clearLocalAuthData();
  }

  /// Clears local auth data from storage
  /// exposing this allows AuthProvider to force clear data when token is invalid
  Future<void> clearLocalAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthRepository.authDataKey);

    try {
      await WalletRepository().clearWalletData();
    } catch (e) {
      log('Failed to clear wallet data: $e');
    }
  }

  // OTP Rate Limiting Private Methods

  /// 載入 OTP 限制數據
  Future<OtpRateLimitData> _loadOtpRateLimitData(String storageKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(storageKey);

      if (dataString == null) {
        return OtpRateLimitData.fresh();
      }

      final decodedData = jsonDecode(dataString);
      if (decodedData is! Map<String, dynamic>) {
        throw FormatException('Invalid OTP rate limit data format');
      }

      return OtpRateLimitData.fromJson(decodedData);
    } catch (e) {
      log('Error loading OTP rate limit data: $e');
      return OtpRateLimitData.fresh(); // 失敗時返回新數據
    }
  }

  /// 儲存 OTP 限制數據
  Future<void> _saveOtpRateLimitData(String storageKey,
      OtpRateLimitData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(storageKey, jsonEncode(data.toJson()));
    } catch (e) {
      log('Error saving OTP rate limit data: $e');
      // 不拋出錯誤，允許操作繼續
    }
  }

  /// 檢查是否超過 OTP 計數限制
  Future<void> _checkOtpRateLimit(String storageKey, String purpose) async {
    var data = await _loadOtpRateLimitData(storageKey);

    // 檢查是否超過 60 分鐘 (將 lastResetDate 視為最後一次重置時間)
    final now = DateTime.now();
    DateTime lastResetTime;
    try {
      lastResetTime = DateTime.parse(data.lastResetDate);
    } catch (_) {
      // 兼容舊資料或錯誤格式，給定一個很早以前的時間
      lastResetTime = now.subtract(const Duration(days: 1));
    }

    if (now.difference(lastResetTime).inMinutes >= 60) {
      // 超過 60 分鐘，計數歸零並更新基準時間
      data = OtpRateLimitData(
        count: 0,
        lastResetDate: now.toIso8601String(),
        timezone: TimezoneHelper.taiwanTimezone,
      );
    }

    // 檢查是否超過限制
    if (data.count >= dailyOtpLimit) {
      throw OtpRateLimitException(
        purpose: purpose,
        limit: dailyOtpLimit,
        used: data.count,
      );
    }
  }

  /// 增加 OTP 計數並儲存
  Future<void> _incrementOtpRateLimit(String storageKey) async {
    var data = await _loadOtpRateLimitData(storageKey);
    final now = DateTime.now();

    DateTime lastResetTime;
    try {
      lastResetTime = DateTime.parse(data.lastResetDate);
    } catch (_) {
      lastResetTime = now.subtract(const Duration(days: 1));
    }

    if (now.difference(lastResetTime).inMinutes >= 60) {
      // 若距上次重置已超過 60 分鐘，這一次算作新的週期 (count = 0 準備被 +1)
      data = OtpRateLimitData(
        count: 0,
        lastResetDate: now.toIso8601String(),
        timezone: TimezoneHelper.taiwanTimezone,
      );
    } else if (data.count == 0) {
      // 如果本來就是 0，代表這是一個新週期的第一筆，將當下當作新的重置基準點
      data = data.copyWith(lastResetDate: now.toIso8601String());
    }

    final updatedData = data.copyWith(count: data.count + 1);
    await _saveOtpRateLimitData(storageKey, updatedData);
  }

  // Registration
  Future<SendOtpResponse> sendRegistrationVerificationCode(String phone) async {
    // 在 API 調用前檢查限制 (不增加計數)
    await _checkOtpRateLimit(
      otpRateLimitRegistrationKey,
      'REGISTER',
    );

    try {
      final response = await _membersService.sendOtp(
        phone: phone,
        purpose: 'REGISTER',
        platform: 'APP',
      );

      // API 呼叫成功後增加計數
      await _incrementOtpRateLimit(otpRateLimitRegistrationKey);
      return response;
    } on ApiException catch (_) {
      // 伺服器有回傳錯誤 (代表有被處理過)，為了防止惡意重試也 +1 
      await _incrementOtpRateLimit(otpRateLimitRegistrationKey);
      rethrow;
    }
    // 其他原生的 Exception (如網路斷線 DioException/SocketException) 則直接往外丟，不扣次數
  }

  Future<VerifyOtpResponse> verifyRegistrationOtp({
    required String phone,
    required String otpCode,
    required String termsAgreedAt,
  }) async {
    try {
      return await _membersService.verifyOtpLogin(
        phone: phone,
        platform: 'APP',
        otpCode: otpCode,
        termsAgreedAt: termsAgreedAt,
      );
    } on ApiException catch (e) {
      // Map specific error codes if needed
      switch (e.code) {
        case ApiErrorCodes.phoneAlreadyRegistered:
        // Code 10001: Phone already registered
          throw AuthenticationException(
            AuthErrorCode.invalidCredentials,
            e.message,
          );
        default:
        // Let OTP-specific errors propagate to UI for specific handling
          rethrow;
      }
    }
  }

  Future<AuthData> register({
    required String phone,
    required String password,
    String? email,
    required String nickname,
    String? gender,
    required String birthday,
    String? areaId,
    String? districtId,
    File? photoFile,
  }) async {
    String? photoStr;
    if (photoFile != null) {
      photoStr = await ImageTools.convertToBase64(photoFile);
    }

    final authData = await _membersService.register(
      phone,
      password,
      email,
      nickname: nickname,
      gender: gender,
      birthday: birthday,
      areaId: areaId,
      districtId: districtId,
      photoStr: photoStr,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AuthRepository.authDataKey, jsonEncode(authData.toJson()));
    final String tmpMemberId = authData.memberId.toString();
    final String userId = F.appFlavor == Flavor.internal
        ? 'internal-$tmpMemberId'
        : tmpMemberId;
    await FirebaseAnalytics.instance.setUserId(id: userId);
    await FirebaseAnalytics.instance.setDefaultEventParameters({'member_id': userId});
    return authData;
  }

  // Password Management
  Future<SendOtpResponse> sendPasswordResetVerificationCode(
      String phone) async {
    // 在 API 調用前檢查限制 (不增加計數)
    await _checkOtpRateLimit(
      otpRateLimitPasswordResetKey,
      'FORGOT_PASSWORD',
    );

    try {
      final response = await _membersService.sendOtp(
        phone: phone,
        purpose: 'FORGOT_PASSWORD',
        platform: 'APP',
      );

      // API 呼叫成功後才增加計數
      await _incrementOtpRateLimit(otpRateLimitPasswordResetKey);
      return response;
    } on ApiException catch (_) {
      // 伺服器有回傳錯誤 (代表有被處理過)，為了防止惡意重試也 +1
      await _incrementOtpRateLimit(otpRateLimitPasswordResetKey);
      rethrow;
    }
  }

  Future<VerifyOtpResetResponse> verifyOtpForPasswordReset({
    required String phone,
    required String otpCode,
  }) async {
    return _membersService.verifyOtpReset(
      phone: phone,
      platform: 'APP',
      otpCode: otpCode,
    );
  }

  Future<AuthData> resetPassword({
    required String memberId,
    required String resetToken,
    required String newPassword,
  }) async {
    final response = await _membersService.resetPassword(
      memberId: memberId,
      resetToken: resetToken,
      newPassword: newPassword,
    );

    // Convert ResetPasswordResponse to AuthData and save it
    final authData = AuthData(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      tokenType: response.tokenType,
      accessTokenExpiresAt: response.accessTokenExpiresAt,
      refreshTokenExpiresAt: response.refreshTokenExpiresAt,
      memberId: response.memberId,
      memberStatus: response.memberStatus,
    );

    // Save auth data to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AuthRepository.authDataKey, jsonEncode(authData.toJson()));

    // Set Firebase Analytics user ID
    final String tmpMemberId = authData.memberId.toString();
    final String userId = F.appFlavor == Flavor.internal
        ? 'internal-$tmpMemberId'
        : tmpMemberId;
    await FirebaseAnalytics.instance.setUserId(id: userId);
    await FirebaseAnalytics.instance.setDefaultEventParameters({'member_id': userId});

    return authData;
  }

  Future<bool> changePassword(AuthData authData,
      String oldPassword,
      String newPassword,) async {
    try {
      return await _membersService.changePassword(oldPassword, newPassword);
    } on ApiException catch (e) {
      // Map error code 10002 to custom user-friendly message
      if (e.code == ApiErrorCodes.invalidCredentials) {
        throw AuthenticationException(
          AuthErrorCode.invalidCredentials,
          '請確認目前密碼是否正確',
        );
      }
      rethrow;
    }
  }

  // Profile Management
  Future<ProfileData> updateProfile({
    required AuthData authData,
    required String nickname,
    String? email,
    String? gender,
    String? birthday,
    String? districtId,
    String? areaId,
  }) async {
    return _membersService.updateProfile(
      nickname,
      email,
      gender,
      birthday ?? "0000-00-00",
      districtId,
      areaId,
    );
  }

  // Account Management
  Future<bool> deleteAccount(AuthData authData,
      String password, {
        required bool agreeToTerms,
        String? reasonId,
        List<String>? subReasonId,
        String? feedback,
      }) async {
    await FirebaseMessagingService.unsubscribeFromAllTopics();
    await FirebaseAnalytics.instance.setUserId(id: null);
    await FirebaseAnalytics.instance.setDefaultEventParameters({'member_id': null});
    return _membersService.deleteAccount(
      password,
      agreeToTerms: agreeToTerms,
      reasonId: reasonId,
      subReasonId: subReasonId,
      feedback: feedback,
    );
  }
}