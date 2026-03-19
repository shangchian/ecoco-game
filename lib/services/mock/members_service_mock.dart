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
import '/services/interface/i_members_service.dart';
import '/services/online/base_service.dart';
import '/database/app_database.dart';
import 'mock_member_coupon_store.dart';

class MembersServiceMock implements IMembersService {
  // Mock test account credentials
  static const String mockPhone = '0912345678';
  static const String mockPassword = '1234';

  // Coupon store for stateful mock
  final MockMemberCouponStore _couponStore = MockMemberCouponStore();

  // Database for syncing coupons from local storage
  AppDatabase? _db;

  void setDatabase(AppDatabase db) {
    _db = db;
  }

  // Mock user data
  static const AuthData mockAuthData = AuthData(
    memberId: "1",
    accessToken: 'mock_access_token_12345',
    refreshToken: 'mock_refresh_token_67890',
    tokenType: 'Bearer',
    accessTokenExpiresAt: '2025-12-31T23:59:59+00:00',
    refreshTokenExpiresAt: '2026-01-31T23:59:59+00:00',
    memberStatus: 'REGISTERED',
  );

  // Mutable mock profile to support updates during session
  ProfileData _mockProfile = ProfileData(
    memberId: "1",
    memberStatus: "REGISTERED",
    phone: mockPhone,
    email: 'test@example.com',
    nickname: '測試用戶',
    gender: 'MALE',
    birthday: '1990-01-01',
    areaId: '1',
    districtId: '1',
    avatarUrl: '',
    isPhoneVerified: true,
    isGenderEditable: false,
    isBirthdayEditable: true,
    lineUserId: null,
    lineBoundAt: null,
  );

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

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
    await _simulateNetworkDelay();

    if (phone == mockPhone && password == mockPassword) {
      return mockAuthData;
    } else {
      throw Exception('Invalid credentials - Use phone: $mockPhone, password: $mockPassword');
    }
  }

  @override
  Future<ProfileData> getProfile() async {
    await _simulateNetworkDelay();

    // In mock mode, we assume the token is always valid if logged in
    return _mockProfile;
  }

  @override
  Future<void> logout() async {
    await _simulateNetworkDelay();
    // Clear coupon store on logout
    _couponStore.clear();
  }

  @override
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
  }) async {
    await _simulateNetworkDelay();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newMemberId = "2";

    // Update mock profile with registered info
    _mockProfile = ProfileData(
      memberId: newMemberId,
      memberStatus: 'REGISTERED',
      phone: phone,
      email: email,
      nickname: nickname,
      gender: gender,
      birthday: birthday,
      areaId: areaId,
      districtId: districtId,
      avatarUrl: photoStr,
      isPhoneVerified: true,
      isGenderEditable: false,
      isBirthdayEditable: true,
    );

    return AuthData(
      memberId: newMemberId,
      accessToken: 'mock_access_token_registered_$timestamp',
      refreshToken: 'mock_refresh_token_registered_$timestamp',
      tokenType: 'Bearer',
      accessTokenExpiresAt: '2025-12-31T23:59:59+00:00',
      refreshTokenExpiresAt: '2026-01-31T23:59:59+00:00',
      memberStatus: 'REGISTERED',
    );
  }

  @override
  Future<SendOtpResponse> sendOtp({
    required String phone,
    required String purpose,
    required String platform,
  }) async {
    await _simulateNetworkDelay();

    // Mock OTP response with realistic timing
    final now = DateTime.now();
    return SendOtpResponse(
      action: SendOtpAction.sent,
      otpExpiresAt: now.add(const Duration(minutes: 3)),
      resendAvailableAt: now.add(const Duration(seconds: 180)),
    );
  }

  @override
  Future<VerifyOtpResponse> verifyOtpLogin({
    required String phone,
    required String platform,
    required String otpCode,
    required String termsAgreedAt,
  }) async {
    await _simulateNetworkDelay();

    // Mock OTP verification - accept any 6-digit code
    if (otpCode.length != 6 || !RegExp(r'^[0-9]{6}$').hasMatch(otpCode)) {
      throw Exception('code: 10006, message: 驗證碼輸入錯誤，請重新輸入');
    }

    // Return mock temporary tokens
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return VerifyOtpResponse(
      accessToken: 'mock_temp_access_token_$timestamp',
      refreshToken: 'mock_temp_refresh_token_$timestamp',
      tokenType: 'Bearer',
      accessTokenExpiresAt: DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
      refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      memberId: 'temp_$timestamp',
      memberStatus: 'TEMPORARY',
    );
  }

  @override
  Future<VerifyOtpResetResponse> verifyOtpReset({
    required String phone,
    required String platform,
    required String otpCode,
  }) async {
    await _simulateNetworkDelay();
    // Mock OTP verification for password reset
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 10));

    return VerifyOtpResetResponse(
      resetToken: 'mock_reset_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: expiresAt.toIso8601String(),
      memberId: '1',
      memberStatus: 'REGISTERED',
    );
  }

  @override
  Future<ResetPasswordResponse> resetPassword({
    required String memberId,
    required String resetToken,
    required String newPassword,
  }) async {
    await _simulateNetworkDelay();
    // Mock password reset - returns auth tokens for automatic login
    final now = DateTime.now();
    final accessTokenExpiry = now.add(const Duration(minutes: 30));
    final refreshTokenExpiry = now.add(const Duration(days: 30));

    return ResetPasswordResponse(
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      tokenType: 'Bearer',
      accessTokenExpiresAt: accessTokenExpiry.toIso8601String(),
      refreshTokenExpiresAt: refreshTokenExpiry.toIso8601String(),
      memberId: '1',
      memberStatus: 'REGISTERED',
    );
  }

  @override
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    await _simulateNetworkDelay();

    // Simulate validation: check if old password matches mock password
    if (oldPassword != mockPassword) {
      // Throw ApiException for wrong password (code 10002)
      throw ApiException(10002, '帳號密碼不匹配');
    }

    // Mock successful password change
    return true;
  }

  @override
  Future<bool> deleteAccount(
    String password, {
    required bool agreeToTerms,
    String? reasonId,
    List<String>? subReasonId,
    String? feedback,
  }) async {
    await _simulateNetworkDelay();

    // Simulate password validation
    if (password != mockPassword) {
      throw ApiException(10002, '帳號密碼不匹配');
    }

    // Simulate agreeToTerms validation
    if (!agreeToTerms) {
      throw Exception('Must agree to terms');
    }

    // Mock account deletion - always succeeds
    return true;
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
    await _simulateNetworkDelay();

    // Update mock profile
    _mockProfile = ProfileData(
      memberId: _mockProfile.memberId,
      memberStatus: _mockProfile.memberStatus,
      phone: _mockProfile.phone,
      email: email ?? _mockProfile.email,
      nickname: nickname,
      gender: gender ?? _mockProfile.gender,
      birthday: birthday,
      areaId: areaId ?? _mockProfile.areaId,
      districtId: districtId ?? _mockProfile.districtId,
      avatarUrl: _mockProfile.avatarUrl,
      isPhoneVerified: _mockProfile.isPhoneVerified,
      isGenderEditable: _mockProfile.isGenderEditable,
      isBirthdayEditable: _mockProfile.isBirthdayEditable,
      lineUserId: _mockProfile.lineUserId,
      lineBoundAt: _mockProfile.lineBoundAt,
    );

    return _mockProfile;
  }

  @override
  Future<AuthData> refreshToken(String refreshToken) async {
    await _simulateNetworkDelay();

    if (refreshToken == mockAuthData.refreshToken || refreshToken.startsWith('mock_refresh_token')) {
      // Return new tokens with updated timestamps
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return AuthData(
        memberId: mockAuthData.memberId,
        accessToken: 'mock_access_token_refreshed_$timestamp',
        refreshToken: 'mock_refresh_token_refreshed_$timestamp',
        tokenType: 'Bearer',
        accessTokenExpiresAt: DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
        refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        memberStatus: mockAuthData.memberStatus,
      );
    } else {
      throw Exception('Invalid refresh token');
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
    await _simulateNetworkDelay();
    // Mock FCM token update - always succeeds
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
    await _simulateNetworkDelay();

    // Mock registration profile update
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return AuthData(
      memberId: timestamp.toString(),
      accessToken: 'mock_registered_access_token_$timestamp',
      refreshToken: 'mock_registered_refresh_token_$timestamp',
      tokenType: 'Bearer',
      accessTokenExpiresAt: DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
      refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      memberStatus: 'REGISTERED',
    );
  }

  @override
  Future<List<MemberCouponModel>> getCoupons({
    String? updatedSince,
    int page = 1,
    int limit = 100,
  }) async {
    await _simulateNetworkDelay();
    await _couponStore.initialize();

    final allCoupons = _couponStore.getCoupons(updatedSince: updatedSince);

    // Pagination
    final startIndex = (page - 1) * limit;
    if (startIndex >= allCoupons.length) return [];

    final endIndex = (startIndex + limit).clamp(0, allCoupons.length);
    return allCoupons.sublist(startIndex, endIndex);
  }

  @override
  Future<FinalizeCouponResponse> finalizeCoupon({
    required String memberCouponId,
    required String idempotencyKey,
  }) async {
    await _simulateNetworkDelay();
    await _couponStore.initialize();

    // Try to get coupon from Mock Store
    var existingCoupon = _couponStore.getCouponById(memberCouponId);

    // If not found, try to sync from database
    if (existingCoupon == null && _db != null) {
      final dbCoupons = await _db!.getMemberCouponsByIds([memberCouponId]);
      if (dbCoupons.isNotEmpty) {
        _couponStore.syncCoupon(dbCoupons.first);
      }
    }

    // Execute finalize
    final coupon = _couponStore.finalizeCoupon(memberCouponId: memberCouponId);

    return FinalizeCouponResponse(
      memberCouponId: memberCouponId,
      status: coupon.currentStatus,
      usedAt: coupon.usedAt!,
    );
  }

  @override
  Future<IssueCouponResponse> issueCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    String? branchCode,
    required String idempotencyKey,
  }) async {
    await _simulateNetworkDelay();
    await _couponStore.initialize();

    final issuedCouponIds = <String>[];
    for (int i = 0; i < exchangeUnits; i++) {
      final coupon = _couponStore.issueCoupon(
        couponRuleId: couponRuleId,
        initialStatus: MemberCouponStatus.active,
      );
      issuedCouponIds.add(coupon.memberCouponId);
    }

    return IssueCouponResponse(
      couponRuleId: couponRuleId,
      exchangeUnits: exchangeUnits,
      totalCost: exchangeUnits * 100, // Mock: 100 points per unit
      issuedCount: exchangeUnits,
      issuedMemberCouponIds: issuedCouponIds,
    );
  }

  @override
  Future<MemberLimitsResponse> getMemberLimits({
    required String couponRuleId,
  }) async {
    await _simulateNetworkDelay();

    // Mock: default to exchangeable
    return MemberLimitsResponse(
      couponRuleId: couponRuleId,
      isExchangeable: true,
      maxExchangeableUnits: 10,
      reasonMessage: null,
    );
  }

  @override
  Future<PrepareCouponResponse> prepareCoupon({
    required String couponRuleId,
    required int exchangeUnits,
    required String idempotencyKey,
  }) async {
    await _simulateNetworkDelay();
    await _couponStore.initialize();

    final coupon = _couponStore.prepareCoupon(couponRuleId: couponRuleId);

    return PrepareCouponResponse(
      memberCouponId: coupon.memberCouponId,
      couponRuleId: couponRuleId,
      exchangedUnits: exchangeUnits,
      totalCost: exchangeUnits * 100, // Mock: 100 points per unit
    );
  }

  @override
  Future<CancelCouponResponse> cancelCoupon({
    required String memberCouponId,
    required String idempotencyKey,
  }) async {
    await _simulateNetworkDelay();

    final coupon = _couponStore.cancelCoupon(memberCouponId: memberCouponId);

    return CancelCouponResponse(
      memberCouponId: memberCouponId,
      newStatus: 'CANCELED',
      pointsRefunded: 100, // Mock refund amount
      canceledAt: coupon.canceledAt!,
    );
  }

  @override
  Future<MemberCouponStatusResponse> getMemberCouponStatus({
    required String memberCouponId,
  }) async {
    await _simulateNetworkDelay();

    final coupon = _couponStore.getCouponById(memberCouponId);
    if (coupon == null) {
      throw ApiException(10010, '查無該筆會員優惠券資產');
    }

    return MemberCouponStatusResponse(
      memberCouponId: memberCouponId,
      couponRuleId: coupon.couponRuleId,
      currentStatus: coupon.currentStatus.name.toUpperCase(),
      isFinalized: _couponStore.isCouponFinalized(memberCouponId: memberCouponId),
      finalizedAt: _couponStore.getFinalizedAt(memberCouponId: memberCouponId),
    );
  }

  /// 取得完整的 MemberCouponModel (Mock Mode 專用)
  /// 用於 prepareCoupon 後直接寫入資料庫，避免增量同步的時序問題
  MemberCouponModel? getMemberCouponById(String memberCouponId) {
    return _couponStore.getCouponById(memberCouponId);
  }
}
