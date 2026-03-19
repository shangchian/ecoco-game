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

/// Interface for Members Service
/// Implemented by both real and mock services
abstract class IMembersService {
  Future<AuthData> login(
    String phone,
    String password, {
    String? fcmToken,
    required String deviceId,
    required String platform,
    required String deviceModel,
    required String osVersion,
  });

  Future<ProfileData> getProfile();

  Future<void> logout();

  Future<AuthData> register(
    String phone,
    String password,
    String? email, {
    required String nickname,
    String? gender,
    required String birthday,
    String? areaId,
    String? districtId,
    String? photoStr,
  });

  /// Send OTP for registration or password reset
  ///
  /// [phone] - Phone number (e.g., "0912345678")
  /// [purpose] - Either "REGISTER" or "FORGOT_PASSWORD"
  /// [platform] - Either "ios" or "android"
  Future<SendOtpResponse> sendOtp({
    required String phone,
    required String purpose,
    required String platform,
  });

  /// Verify OTP for registration login
  ///
  /// [phone] - Phone number (e.g., "0912345678")
  /// [platform] - "APP" for mobile app
  /// [otpCode] - 6-digit OTP code
  /// [termsAgreedAt] - Timestamp when user agreed to terms (ISO 8601 UTC)
  ///
  /// Returns temporary tokens with memberStatus "TEMPORARY"
  /// Throws exception with code 10005 if OTP expired
  /// Throws exception with code 10006 if OTP is incorrect
  Future<VerifyOtpResponse> verifyOtpLogin({
    required String phone,
    required String platform,
    required String otpCode,
    required String termsAgreedAt,
  });

  /// Verify OTP for password reset flow
  ///
  /// [phone] - Phone number (e.g., "0912345678")
  /// [platform] - "APP" for mobile app
  /// [otpCode] - 6-digit OTP code
  ///
  /// Returns resetToken and expiresAt for use in reset password endpoint
  /// Throws exception with code 10005 if OTP expired
  /// Throws exception with code 10006 if OTP is incorrect
  Future<VerifyOtpResetResponse> verifyOtpReset({
    required String phone,
    required String platform,
    required String otpCode,
  });

  /// Reset password using resetToken from OTP verification
  ///
  /// [memberId] - Member UID received from verifyOtpReset
  /// [resetToken] - Token received from verifyOtpReset
  /// [newPassword] - New password to set
  ///
  /// Returns access and refresh tokens for automatic login
  /// Throws exception with code 10005 if resetToken expired
  Future<ResetPasswordResponse> resetPassword({
    required String memberId,
    required String resetToken,
    required String newPassword,
  });

  /// Change member password (requires re-login after success)
  ///
  /// Endpoint: PUT /member/password
  /// Authentication: Bearer token in Authorization header
  /// Requires: X-Firebase-AppCheck header (high-risk operation)
  ///
  /// [authData] - Current authentication data containing access token
  /// [oldPassword] - Current password for verification
  /// [newPassword] - New password to set
  ///
  /// Returns true if password change was successful
  ///
  /// **IMPORTANT**: Server immediately invalidates both Access Token and Refresh Token
  /// after successful password change. The caller MUST handle logout and force user
  /// to re-login with the new password.
  ///
  /// Error codes:
  /// - 10002: Old password is incorrect (帳號密碼不匹配)
  /// - 400: Bad request (invalid parameters)
  /// - 401: Unauthorized (token validation failed)
  ///
  /// Throws [ApiException] with error code and message for all failures
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  );

  /// Delete member account (requires re-authentication and consent)
  ///
  /// Endpoint: DELETE /member/account
  /// Authentication: Bearer token in Authorization header
  /// Requires: X-Firebase-AppCheck header (high-risk operation)
  ///
  /// [authData] - Current authentication data containing access token
  /// [password] - Current password for verification
  /// [agreeToTerms] - User must agree to permanent deletion (must be true)
  /// [reasonId] - Selected main reason kind ID (optional)
  /// [subReasonId] - List of selected sub-reason IDs (optional)
  /// [feedback] - User's additional feedback text (optional)
  ///
  /// Returns true if account deletion was successful
  ///
  /// **IMPORTANT**: Server permanently deletes all member data and PII
  /// after successful deletion. This action cannot be undone.
  Future<bool> deleteAccount(
    String password, {
    required bool agreeToTerms,
    String? reasonId,
    List<String>? subReasonId,
    String? feedback,
  });

  Future<ProfileData> updateProfile(
    String nickname,
    String? email,
    String? gender,
    String birthday,
    String? districtId,
    String? areaId,
  );

  Future<AuthData> refreshToken(String refreshToken);

  /// Update FCM token on server
  ///
  /// [authData] - Current authentication data containing access token
  /// [fcmToken] - Firebase Cloud Messaging token
  /// [deviceId] - Unique device identifier
  /// [platform] - Device platform (e.g., "IOS", "ANDROID")
  /// [deviceModel] - Device model name
  /// [osVersion] - Operating system version
  ///
  /// This should be called whenever Firebase provides a new FCM token
  /// Requires user to be authenticated (uses Bearer token)
  Future<void> updateFcmToken({
    required String fcmToken,
    required String deviceId,
    required String platform,
    required String deviceModel,
    required String osVersion,
  });

  /// Update registration profile (final step in registration flow)
  ///
  /// [accessToken] - Access token from OTP verification
  /// [password] - Member password (8-20 chars, must contain letters and numbers)
  /// [email] - Member email (optional, can be null)
  /// [nickname] - Display name for member
  /// [gender] - Gender: "MALE", "FEMALE", "OTHER", or null
  /// [birthday] - Date of birth in YYYY-MM-DD format
  /// [areaId] - Area/county ID (optional, can be null)
  /// [districtId] - District ID based on areaId (optional, can be null)
  ///
  /// Returns updated AuthData with memberStatus changed from TEMPORARY to REGISTERED
  /// Requires X-Firebase-AppCheck header
  Future<AuthData> updateRegistrationProfile({
    required String accessToken,
    required String password,
    String? email,
    required String nickname,
    String? gender,
    required String birthday,
    String? areaId,
    String? districtId,
  });

  /// Get member coupons list with incremental sync support
  ///
  /// [updatedSince] - Last successful sync timestamp (ISO 8601)
  /// [page] - Page number (default 1)
  /// [limit] - Items per page (default 100)
  Future<List<MemberCouponModel>> getCoupons({
    String? updatedSince,
    int page = 1,
    int limit = 100,
  });

  /// Finalize a coupon usage
  ///
  /// [memberCouponId] - The ID of the coupon to finalize
  /// [idempotencyKey] - Unique key to prevent double debit
  Future<FinalizeCouponResponse> finalizeCoupon({
    required String memberCouponId,
    required String idempotencyKey,
  });

  /// Issue a coupon (exchange points for coupon)
  ///
  /// Endpoint: POST /exchange/coupons/{couponRuleId}/issue
  /// Authentication: Bearer token in Authorization header
  ///
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  /// [branchCode] - Optional branch verification code entered by staff
  /// [idempotencyKey] - Unique key to prevent double debit
  ///
  /// Returns issued coupon information including memberCouponIds
  ///
  /// Error codes:
  /// - 10004: Account locked due to security reasons
  /// - 30006: Insufficient points
  /// - 30012: Coupon campaign not started yet
  /// - 30013: Coupon campaign has ended
  /// - 30014: Campaign sold out (insufficient inventory)
  /// - 30015: Exchange limit reached
  /// - 30016: Duplicate request (idempotency key collision)
  Future<IssueCouponResponse> issueCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    String? branchCode,
    required String idempotencyKey,
  });

  /// Get member limits for a coupon rule
  ///
  /// Endpoint: GET /coupons/{couponRuleId}/member-limits
  /// Authentication: Bearer token in Authorization header
  ///
  /// [couponRuleId] - The coupon rule UID to check limits for
  ///
  /// Returns member exchange limit status including:
  /// - isExchangeable: Whether member can exchange this coupon
  /// - maxExchangeableUnits: Maximum units member can exchange
  /// - reasonMessage: Reason if not exchangeable (e.g., "已達兌換上限", "點數餘額不足")
  ///
  /// Error codes:
  /// - 10004: Account locked due to security reasons
  /// - 30006: Insufficient points
  /// - 30012: Coupon campaign not started yet
  /// - 30013: Coupon campaign has ended
  /// - 30014: Campaign sold out (insufficient inventory)
  /// - 30015: Exchange limit reached
  Future<MemberLimitsResponse> getMemberLimits({
    required String couponRuleId,
  });

  /// Prepare a coupon for POS redemption (creates HOLDING status coupon)
  ///
  /// Endpoint: POST /exchange/coupons/{couponRuleId}/prepare
  /// Authentication: Bearer token in Authorization header
  ///
  /// [couponRuleId] - The coupon rule UID to exchange
  /// [exchangeUnits] - Number of units to exchange (must be >= 1)
  /// [idempotencyKey] - Unique key to prevent double debit
  ///
  /// Returns prepared coupon information including memberCouponId
  /// The HOLDING status coupon has a 5-minute validity period
  ///
  /// Error codes:
  /// - 10004: Account locked due to security reasons
  /// - 30006: Insufficient points
  /// - 30012: Coupon campaign not started yet
  /// - 30013: Coupon campaign has ended
  /// - 30014: Campaign sold out (insufficient inventory)
  /// - 30015: Exchange limit reached
  /// - 30016: Duplicate request (idempotency key collision)
  Future<PrepareCouponResponse> prepareCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    required String idempotencyKey,
  });

  /// Cancel a HOLDING status coupon
  ///
  /// Endpoint: POST /exchange/coupons/{memberCouponId}/cancel
  /// Authentication: Bearer token in Authorization header
  ///
  /// [memberCouponId] - The member coupon UID to cancel
  /// [idempotencyKey] - Unique key to prevent duplicate requests
  ///
  /// Returns cancel confirmation including refunded points
  /// Only HOLDING status coupons can be canceled
  ///
  /// Error codes:
  /// - 30002: Coupon not found
  /// - 30003: Coupon already used
  /// - 30016: Duplicate request (idempotency key collision)
  /// - 30017: Coupon already canceled
  Future<CancelCouponResponse> cancelCoupon({
    required String memberCouponId,
    required String idempotencyKey,
  });

  /// Get current status of a member coupon
  ///
  /// Endpoint: GET /member/coupons/{memberCouponId}/status
  /// Authentication: Bearer token in Authorization header
  ///
  /// [memberCouponId] - The member coupon UID to check
  ///
  /// Returns current status information for POS flow status confirmation
  /// Used for polling during POS redemption to detect silent notification updates
  ///
  /// Error codes:
  /// - 10010: Coupon not found for this member
  /// - 10011: Unexpected current status (polling canceled)
  Future<MemberCouponStatusResponse> getMemberCouponStatus({
    required String memberCouponId,
  });
}