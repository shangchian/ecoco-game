import '/models/auth_data_model.dart';
import '/models/send_otp_response_model.dart';
import '/models/verify_otp_response_model.dart';
import '/models/verify_otp_reset_response_model.dart';
import '/models/reset_password_response_model.dart';
import '/models/profile_data_model.dart';
import '/models/member_coupon_model.dart';
import '/models/finalize_coupon_response.dart';
import '/models/issue_coupon_response.dart';
import '/models/prepare_coupon_response.dart';
import '/models/member_limits_response.dart';
import '/models/cancel_coupon_response.dart';
import '/models/member_coupon_status_response.dart';
import '/utils/json_parsing_utils.dart';
import 'base_service.dart';
import '/services/interface/i_members_service.dart';
import 'package:dio/dio.dart';

class MemberAuthException implements Exception {
  final String message;
  MemberAuthException(this.message);

  @override
  String toString() => message;
}

class NoBiometricAuthDataException extends MemberAuthException {
  NoBiometricAuthDataException() : super('No biometric data found');
}

class MembersService extends BaseService implements IMembersService {
  MembersService({
    super.onTokenRefreshed,
    super.onRefreshFailed,
  });

  @override
  Future<AuthData> login(
    String phone,
    String password, {
    String? fcmToken,
    required String deviceId,
    required String platform,
    required String deviceModel,
    required String osVersion,
  }) async {
    try {
      final data = {
        "phone": phone,
        "password": password,
        "deviceId": deviceId,
        "platform": platform,
        "deviceModel": deviceModel,
        "osVersion": osVersion,
      };

      if (fcmToken != null) {
        data["fcmToken"] = fcmToken;
      }

      // Use dioWithAppCheck for login to include X-Firebase-AppCheck header
      final response = await dioWithAppCheck.post('/auth/login', data: data);

      validateResponse(response);

      // Check API response code for success
      final int code = parseResponseCode(response.data);
      if (code == 0) {
        // Code 0: Success - login successful
        return AuthData.fromJson(response.data['result']);
      } else {
        // Non-zero code means error - throw ApiException with code and message
        throw ApiException(
          code,
          response.data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<ProfileData> getProfile() async {
    try {
      final response = await dio.get(
        '/member/profile',
      );
      validateResponse(response);

      return ProfileData.fromJson(response.data['result']);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Set Bearer token in Authorization header
      await dio.post(
        '/auth/logout',
        data: {},
      );
    } catch (e) {
      //throw handleError(e);
    }
  }

  @override
  Future<AuthData> register(String phone, String password, String? email,
      {required String nickname,
       String? gender,
       required String birthday,
       String? areaId,
       String? districtId,
       String? photoStr}) async {
    try {
      final data = {
        "phone": phone,
        "password": password,
        "nickname": nickname,
        "birthday": birthday,
      };

      if (email != null && email.isNotEmpty) {
        data["email"] = email;
      }

      if (gender != null && gender.isNotEmpty) {
        data["gender"] = gender.toUpperCase();
      }

      if (areaId != null) {
        data["area_id"] = areaId;
      }

      if (districtId != null) {
        data["district_id"] = districtId;
      }

      if (photoStr != null) {
        data["avatar_url"] = photoStr;
      }

      final response = await dio.post('/members/register', data: data);

      validateResponse(response);
      return AuthData.fromJson(response.data['dataResult']);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<SendOtpResponse> sendOtp({
    required String phone,
    required String purpose,
    required String platform,
  }) async {
    try {
      final response = await dioWithAppCheck.post('/auth/send-otp', data: {
        "phone": phone,
        "purpose": purpose,
        "platform": platform,
      });

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      final String message = response.data['message'] ?? '';

      if (code != 0) {
        throw ApiException(code, message);
      }

      // Parse the result object from the response
      final result = response.data['result'];
      return SendOtpResponse.fromJson(result);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<VerifyOtpResponse> verifyOtpLogin({
    required String phone,
    required String platform,
    required String otpCode,
    required String termsAgreedAt,
  }) async {
    try {
      final response = await dioWithAppCheck.post('/auth/verify-otp-login', data: {
        "phone": phone,
        "platform": platform,
        "otpCode": otpCode,
        "termsAgreedAt": termsAgreedAt,
      });

      validateResponse(response);

      // Check API response code
      final int code = parseResponseCode(response.data);
      if (code == 0 || code == 10009) {
        // Code 0: Success - new registration
        // Code 10009: Registration incomplete - returns TEMPORARY tokens, allow continuation
        final result = response.data['result'];
        return VerifyOtpResponse.fromJson(result);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<VerifyOtpResetResponse> verifyOtpReset({
    required String phone,
    required String platform,
    required String otpCode,
  }) async {
    try {
      final response = await dioWithAppCheck.post('/auth/verify-otp-reset', data: {
        "phone": phone,
        "platform": platform,
        "otpCode": otpCode,
      });
      validateResponse(response);

      // Check application-level error codes in response body
      // Even with HTTP 200, the API may return error codes: 10005, 10006, 10003
      final int code = parseResponseCode(response.data);
      final String message = response.data['message'] ?? '';

      if (code != 0) {
        // Throw ApiException with the error code for type-safe handling downstream
        throw ApiException(code, message);
      }

      final result = response.data['result'];
      return VerifyOtpResetResponse.fromJson(result);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<ResetPasswordResponse> resetPassword({
    required String memberId,
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await dioWithAppCheck.post('/auth/reset-password', data: {
        "memberId": memberId,
        "resetToken": resetToken,
        "newPassword": newPassword,
      });
      validateResponse(response);
      final result = response.data['result'];
      return ResetPasswordResponse.fromJson(result);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await dioWithAppCheck.put(
        '/member/password',
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
      );
      validateResponse(response);

      // Check response code for success
      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return true;
      } else {
        // Throw ApiException for non-zero codes
        throw ApiException(
          code,
          response.data['message'] ?? 'Password change failed',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<bool> deleteAccount(
    String password, {
    required bool agreeToTerms,
    String? reasonId,
    List<String>? subReasonId,
    String? feedback,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "password": password,
        "agreeToTerms": agreeToTerms,
      };

      if (reasonId != null) {
        data["reasonKindId"] = reasonId;
      }

      if (subReasonId != null && subReasonId.isNotEmpty) {
        data["reasonIds"] = subReasonId;
      } else {
        data["reasonIds"] = null;
      }

      if (feedback != null && feedback.isNotEmpty) {
        data["feedback"] = feedback;
      } else {
        data["feedback"] = null;
      }

      final response = await dioWithAppCheck.delete(
        '/member/account',
        data: data,
      );

      validateResponse(response);
      return parseResponseCode(response.data) == 0;
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<ProfileData> updateProfile(
    String nickname,
    String? email,
    String? gender,
    String birthday,
    String? districtId,
    String? areaId,
  ) async {
    try {
      final data = <String, dynamic>{
        "nickname": nickname,
        "birthday": birthday,
      };

      if (email != null && email.isNotEmpty) {
        data["email"] = email;
      }

      if (gender != null && gender.isNotEmpty) {
        data["gender"] = gender.toUpperCase();
      } else {
        data["gender"] = null;
      }

      if (areaId != null) {
        data["areaId"] = areaId;
      } else {
        data["gender"] = null;
      }

      if (districtId != null) {
        data["districtId"] = districtId;
      } else {
        data["gender"] = null;
      }

      final response = await dio.patch(
        '/member/profile',
        data: data,
      );

      validateResponse(response);
      return ProfileData.fromJson(response.data['result']);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<AuthData> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post('/auth/refresh-token', data: {
        "refreshToken": refreshToken,
      });

      validateResponse(response);
      return AuthData.fromJson(response.data['result']);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceId,
    required String platform,
    required String deviceModel,
    required String osVersion,
  }) async {
    try {
      final response = await dio.put(
        '/member/fcm-token',
        data: {
          "fcmToken": fcmToken,
          "deviceId": deviceId,
          "platform": platform,
          "deviceModel": deviceModel,
          "osVersion": osVersion,
        },
      );

      validateResponse(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<AuthData> updateRegistrationProfile({
    required String accessToken,
    required String password,
    String? email,
    required String nickname,
    String? gender,
    required String birthday,
    String? areaId,
    String? districtId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "password": password,
        "nickname": nickname,
        "birthday": birthday,
      };

      // Add optional fields only if not null
      if (email != null && email.isNotEmpty) {
        data["email"] = email;
      } else {
        data["email"] = null;
      }
      if (gender != null && gender.isNotEmpty) {
        data["gender"] = gender.toUpperCase();
      } else {
        data["gender"] = null;
      }
      if (areaId != null) {
        data["areaId"] = areaId;
      } else {
        data["areaId"] = null;
      }
      if (districtId != null) {
        data["districtId"] = districtId;
      } else {
        data["districtId"] = null;
      }

      // Use dioWithAppCheck for X-Firebase-AppCheck header
      final response = await dioWithAppCheck.put(
        '/member/profile',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code != 0) {
        throw ApiException(
          code,
          response.data['message'] ?? 'Update profile failed',
        );
      }

      return AuthData.fromJson(response.data['result']);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<List<MemberCouponModel>> getCoupons({
    String? updatedSince,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (updatedSince != null) {
        queryParams['updated_since'] = updatedSince;
      }

      final response = await dio.get(
        '/member/coupons',
        queryParameters: queryParams,
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        final list = response.data['result']['list'] as List;
        return list
            .map((e) => MemberCouponModel.fromJson(e))
            .toList();
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to get coupons',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<FinalizeCouponResponse> finalizeCoupon({
    required String memberCouponId,
    required String idempotencyKey,
  }) async {
    try {
      final response = await dio.post(
        '/member/coupons/$memberCouponId/finalize',
        options: Options(
          headers: {
            'X-Idempotency-Key': idempotencyKey,
          },
        ),
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return FinalizeCouponResponse.fromJson(response.data['result']);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to finalize coupon',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<IssueCouponResponse> issueCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    String? branchCode,
    required String idempotencyKey,
  }) async {
    try {
      final data = <String, dynamic>{
        'exchangeUnits': exchangeUnits,
        'branchCode': branchCode,
      };

      final response = await dio.post(
        '/exchange/coupons/$couponRuleId/issue',
        data: data,
        options: Options(
          headers: {
            'X-Idempotency-Key': idempotencyKey,
          },
        ),
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return IssueCouponResponse.fromJson(response.data['result']);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to issue coupon',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<MemberLimitsResponse> getMemberLimits({
    required String couponRuleId,
  }) async {
    try {
      final response = await dio.get(
        '/coupons/$couponRuleId/member-limits',
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return MemberLimitsResponse.fromJson(response.data['result']);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? '無法取得使用限制',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<PrepareCouponResponse> prepareCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    required String idempotencyKey,
  }) async {
    try {
      final data = <String, dynamic>{
        'exchangeUnits': exchangeUnits,
      };

      final response = await dio.post(
        '/exchange/coupons/$couponRuleId/prepare',
        data: data,
        options: Options(
          headers: {
            'X-Idempotency-Key': idempotencyKey,
          },
        ),
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return PrepareCouponResponse.fromJson(response.data['result']);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to prepare coupon',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<CancelCouponResponse> cancelCoupon({
    required String memberCouponId,
    required String idempotencyKey,
  }) async {
    try {
      final response = await dio.post(
        '/exchange/coupons/$memberCouponId/cancel',
        options: Options(
          headers: {
            'X-Idempotency-Key': idempotencyKey,
          },
        ),
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return CancelCouponResponse.fromJson(response.data['result']);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to cancel coupon',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<MemberCouponStatusResponse> getMemberCouponStatus({
    required String memberCouponId,
  }) async {
    try {
      final response = await dio.get(
        '/member/coupons/$memberCouponId/status',
      );

      validateResponse(response);

      final int code = parseResponseCode(response.data);
      if (code == 0) {
        return MemberCouponStatusResponse.fromJson(response.data['result']);
      } else {
        throw ApiException(
          code,
          response.data['message'] ?? 'Failed to get coupon status',
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

}