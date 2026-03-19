import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/legacy.dart';

import '/providers/avatar_provider.dart';
import '/providers/member_coupon_provider.dart';
import '/providers/notification_repository_provider.dart';
import '/providers/members_service_provider.dart';
import '/providers/points_history_provider.dart';
import '/providers/site_repository_provider.dart';
import '/providers/voucher_seen_provider.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/auth_data_model.dart';
import '/models/send_otp_response_model.dart';
import '/models/verify_otp_response_model.dart';
import '/models/verify_otp_reset_response_model.dart';
import '/repositories/auth_repository.dart';
import '/services/initialization_service.dart';


import '/providers/profile_provider.dart';
import '/providers/bio_provider.dart';

part 'auth_provider.g.dart';

/// Exception thrown when a user has verified phone but not completed registration
class IncompleteRegistrationException implements Exception {
  final AuthData authData;

  IncompleteRegistrationException(this.authData);

  @override
  String toString() => '請完成註冊流程';
}

/// Exception thrown when user is not authenticated
class NotAuthenticatedException implements Exception {
  @override
  String toString() => '未登入';
}

/// Exception thrown when token refresh fails
class TokenRefreshFailedException implements Exception {
  final String message;

  TokenRefreshFailedException([this.message = 'Token refresh failed']);

  @override
  String toString() => message;
}

final logoutReasonProvider = StateProvider<String?>((ref) => null);

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  AuthRepository? _authRepository;

  // Lazy initialization of repository to avoid circular dependency
  AuthRepository get _repository {
    _authRepository ??= AuthRepository(
      membersService: ref.read(membersServiceProvider),
    );
    return _authRepository!;
  }

  @override
  AuthData? build() {
    // Don't initialize repository here to avoid circular dependency
    // It will be initialized lazily when first accessed
    return null;
  }

  /// Update auth data directly (used by token refresh callback)
  void updateAuthData(AuthData newAuthData) {
    state = newAuthData;
  }

  Future<void> initialize() async {
    try {
      final authData = await _repository.getLoggedInData();
      if (authData != null) {
        await _handleLoginSuccess(authData);
      } else {
        state = null;
      }
    } catch (e) {
      log('AUTH: Silent initialization error: $e');
      // If it's a TEMPORARY/BLOCKED status error, clear data
      if (e is IncompleteRegistrationException || 
          (e is AuthenticationException && e.code == AuthErrorCode.unauthorized)) {
        await _repository.clearLocalAuthData();
      }
      state = null;
    }
  }

  Future<void> login(String username, String password,
      {bool bypassStateIfErr = false}) async {
    try {
      final authData = await _repository.login(username, password);
      if (!ref.mounted) return;
      await _handleLoginSuccess(authData);
    } catch (e) {
      if (!bypassStateIfErr && ref.mounted) {
        state = null;
      }
      rethrow;
    }
  }

  /// Unified handler for successful login response (Manual or Biometric)
  Future<void> _handleLoginSuccess(AuthData authData) async {
    // 1. Check member status
    if (authData.memberStatus == 'TEMPORARY') {
      throw IncompleteRegistrationException(authData);
    } else if (authData.memberStatus == 'BLOCKED') {
      throw AuthenticationException(
        AuthErrorCode.unauthorized,
        '此帳號因安全因素而被封鎖',
      );
    } else if (authData.memberStatus != 'REGISTERED') {
      throw AuthenticationException(
        AuthErrorCode.unknown,
        '帳號狀態異常，請聯繫客服',
      );
    }

    // 2. Set state
    state = authData;

    // 3. Initialize profile, notifications, stats etc.
    try {
      log('AUTH: Performing unified post-auth initialization');
      await performPostAuthInitialization().timeout(const Duration(seconds: 10));
    } catch (e) {
      log('AUTH: Post-auth initialization error: $e');
      // Continue anyway, as we have the auth token and state set
    }
  }

  bool _isManualLogout = false;

  Future<void> logout() async {
    log('LOGOUT: Starting manual logout');
    _isManualLogout = true;
    // Clear any previous error reasons so manual logout is clean
    ref.read(logoutReasonProvider.notifier).state = null;
    
    final currentState = state;
    if (currentState != null) {
      /* // 0. Remove biometric data - Keep for next login
      try {
        await ref.read(bioProvider.notifier).deleteBiometricData();
      } catch (e) {
        log('LOGOUT: Error deleting biometric data: $e');
      } */

      // 1. Unregister notifications (Safe wrap to prevent hanging)
      try {
        log('LOGOUT: Unregistering notifications...');
        await ref
            .read(notificationRepositoryProvider)
            .unregisterNotifications()
            .timeout(const Duration(seconds: 3));
        log('LOGOUT: Unregistering notifications done');
      } catch (e) {
        log('LOGOUT: Error/Timeout unregistering notifications: $e');
      }

      // 2. Call Repo logout
      try {
        log('LOGOUT: Calling repository logout API...');
        await _repository.logout(currentState).timeout(const Duration(seconds: 5));
        log('LOGOUT: Repository logout API done');
      } catch (e) {
        log('LOGOUT: Error/Timeout in repository logout: $e');
      }

      if (!ref.mounted) {
        log('LOGOUT: Ref not mounted, stopping');
        _isManualLogout = false;
        return;
      }

      // Clear site statuses (Sites are NOT cleared - preserved for next login)
      try {
        final siteRepo = ref.read(siteRepositoryProvider);
        await siteRepo.clearStatusesOnLogout();
      } catch (e) {
        // Log but don't block logout
        log('Error clearing site statuses on logout: $e');
      }

      // Clear seen voucher records
      try {
        await ref.read(voucherSeenProvider.notifier).clearSeenVouchers();
      } catch (e) {
        log('Error clearing seen vouchers on logout: $e');
      }

      // Clear member coupons and sync cursor
      try {
        final memberCouponRepo = ref.read(memberCouponRepositoryProvider);
        await memberCouponRepo.clearOnLogout();
      } catch (e) {
        log('Error clearing member coupons on logout: $e');
      }

      // Clear point logs
      try {
        await ref.read(pointsHistoryProvider.notifier).clear();
      } catch (e) {
        log('Error clearing points history on logout: $e');
      }

      log('LOGOUT: Clearing avatar and profile...');
      ref.read(avatarProvider.notifier).reset();
      ref.read(profileProvider.notifier).clear();
      
      log('LOGOUT: Setting state to null (Triggering navigation)');
      state = null;
    } else {
      log('LOGOUT: Current state is null, nothing to do');
    }
    _isManualLogout = false;
  }

  /// Force logout without calling the API (used when token is invalid/expired)
  Future<void> forceLogout() async {
    log('LOGOUT: Starting force logout');
    if (_isManualLogout) {
      log('LOGOUT: Ignored forceLogout because manual logout is in progress');
      ref.read(logoutReasonProvider.notifier).state = null; // Clean up any rogue messages
      return;
    }
    
    final currentState = state;
    if (currentState != null) {
      /* // 0. Remove biometric data - Keep for next login
      try {
        await ref.read(bioProvider.notifier).deleteBiometricData();
      } catch (e) {
        log('LOGOUT: Error deleting biometric data (force): $e');
      } */

      // 1. Unregister notifications (Safe wrap to prevent hanging)
      try {
        log('LOGOUT: Unregistering notifications (force)...');
        await ref
            .read(notificationRepositoryProvider)
            .unregisterNotifications()
            .timeout(const Duration(seconds: 3));
        log('LOGOUT: Unregistering notifications done');
      } catch (e) {
        log('LOGOUT: Error/Timeout unregistering notifications in force logout: $e');
      }
      
      // Skip API call since token is invalid
      
      // 2. Clear local auth data (SharedPrefs) to prevent auto-login on restart
      log('LOGOUT: Clearing local auth data...');
      await _repository.clearLocalAuthData();

      if (!ref.mounted) return;

      // Clear site statuses
      try {
        final siteRepo = ref.read(siteRepositoryProvider);
        await siteRepo.clearStatusesOnLogout();
      } catch (e) {
        log('Error clearing site statuses on force logout: $e');
      }

      // Clear seen voucher records
      try {
        await ref.read(voucherSeenProvider.notifier).clearSeenVouchers();
      } catch (e) {
        log('Error clearing seen vouchers on force logout: $e');
      }

      // Clear member coupons and sync cursor
      try {
        final memberCouponRepo = ref.read(memberCouponRepositoryProvider);
        await memberCouponRepo.clearOnLogout();
      } catch (e) {
        log('Error clearing member coupons on force logout: $e');
      }

      // Clear point logs
      try {
        await ref.read(pointsHistoryProvider.notifier).clear();
      } catch (e) {
        log('Error clearing points history on force logout: $e');
      }

      ref.read(avatarProvider.notifier).reset();
      ref.read(profileProvider.notifier).clear();
      state = null;
    }
  }

  Future<void> register({
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
    try {
      final authData = await _repository.register(
        phone: phone,
        password: password,
        email: email,
        nickname: nickname,
        gender: gender,
        birthday: birthday,
        areaId: areaId,
        districtId: districtId,
        photoFile: photoFile,
      );
      if (!ref.mounted) return;
      state = authData;
      // Fetch profile after registration
      await ref.read(profileProvider.notifier).fetchProfile();
    } catch (e) {
      if (ref.mounted) {
        state = null;
      }
      rethrow;
    }
  }

  // Removed getInfo from here, it's now handled by ProfileNotifier.fetchProfile
  // But we might need to keep a dummy or proxy if calls are widespread?
  // No, I should refactor the calls.
  
  /// Perform post-authentication initialization sequence
  /// This runs a sequential process including getInfo() and other initialization steps
  /// Called after: login, app startup, registration completion, password reset
  Future<InitializationResult> performPostAuthInitialization() async {
    if (state == null) return InitializationResult.empty();

    // Profile is loaded in the first step of runInitialization
    // await ref.read(profileProvider.notifier).fetchProfile();

    final initService = InitializationService(
      membersService: ref.read(membersServiceProvider),
      notificationRepository: ref.read(notificationRepositoryProvider),
    );
    return await initService.runInitialization(state!, ref);
  }

  Future<SendOtpResponse> sendVerificationCode(String phone) async {
    return await _repository.sendRegistrationVerificationCode(phone);
  }

  Future<SendOtpResponse> sendForgetPasswordVerificationCode(String phone) async {
    return await _repository.sendPasswordResetVerificationCode(phone);
  }

  /// Verify OTP for registration and get temporary tokens
  /// Does NOT update the auth state - tokens should be stored in page state
  Future<VerifyOtpResponse> verifyRegistrationOtp({
    required String phone,
    required String otpCode,
    required String termsAgreedAt,
  }) async {
    return await _repository.verifyRegistrationOtp(
      phone: phone,
      otpCode: otpCode,
      termsAgreedAt: termsAgreedAt,
    );
  }

  /// Verify OTP for password reset flow and get resetToken
  /// Does NOT update the auth state - resetToken should be stored in page state
  Future<VerifyOtpResetResponse> verifyOtpForPasswordReset({
    required String phone,
    required String otpCode,
  }) async {
    return await _repository.verifyOtpForPasswordReset(
      phone: phone,
      otpCode: otpCode,
    );
  }

  Future<AuthData?> loginUsingBiometric({VoidCallback? onAuthenticated}) async {
    log('AUTH: Starting loginUsingBiometric');
    try {
      final bioNotifier = ref.read(bioProvider.notifier);
      
      // 先檢查本地標記，避免觸發系統彈窗 (即使檔案不存在，某些 Android 版本 read 仍會彈窗)
      final isSaved = await bioNotifier.isSaveBiometricData();
      if (!isSaved) {
        log('AUTH: No biometric data saved in prefs, skipping prompt');
        throw AuthenticationException(AuthErrorCode.noData, 'No biometric data saved');
      }

      final authenticate = await bioNotifier.checkAuthenticate();
      log('AUTH: checkAuthenticate result: $authenticate');
      
      if (authenticate == CanAuthenticateResponse.errorHwUnavailable || 
          authenticate == CanAuthenticateResponse.errorNoHardware) {
        log('AUTH: Biometric hardware not supported');
        throw AuthenticationException(AuthErrorCode.unSupported, 'Device does not support biometric authentication');
      }

      if (authenticate == CanAuthenticateResponse.errorNoBiometricEnrolled) {
        log('AUTH: No biometric enrolled in system');
        // We still treat this as "no data" or a specific "not enrolled" case
        // so the UI can decide whether to show the button or not.
        throw AuthenticationException(AuthErrorCode.noData, 'No biometric enrolled in system settings');
      }

      final supportsAuthenticated =
          authenticate == CanAuthenticateResponse.success ||
              authenticate == CanAuthenticateResponse.statusUnknown;

      if (!supportsAuthenticated) {
        log('AUTH: Biometric cannot be used right now: $authenticate');
        throw AuthenticationException(AuthErrorCode.unSupported, 'Biometric authentication is currently unavailable');
      }

      final bioAuthData = await bioNotifier.getBiometricData();
      if (bioAuthData == null) {
        log('AUTH: No biometric data found');
        throw AuthenticationException(AuthErrorCode.noData, 'No biometric data found');
      }
      log('AUTH: Biometric data retrieved, performing login for ${bioAuthData.phone}');

      // Call the callback now that we have authenticated
      onAuthenticated?.call();

      if (bioAuthData.password.isEmpty || bioAuthData.phone.isEmpty) {
        throw AuthenticationException(
            AuthErrorCode.invalidCredentials, 'Invalid biometric data');
      }

      final authData =
          await _repository.login(bioAuthData.phone, bioAuthData.password);
      
      if (!ref.mounted) return authData;

      // Use the unified handler to check status and initialize data
      await _handleLoginSuccess(authData);

      return authData;
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password using resetToken and automatically login
  /// Updates the auth state with the new login session
  Future<void> resetPassword({
    required String memberId,
    required String resetToken,
    required String newPassword,
  }) async {
    final authData = await _repository.resetPassword(
      memberId: memberId,
      resetToken: resetToken,
      newPassword: newPassword,
    );

    if (ref.mounted) {
      // Delete biometric data if exists
      try {
        await ref.read(bioProvider.notifier).deleteBiometricData();
      } catch (e) {
        log('Error deleting biometric data on password reset: $e');
      }

      // Update auth state with the new login session
      state = authData;
      await ref.read(profileProvider.notifier).fetchProfile();
    }
  }

  /// 變更密碼，成功後回傳 true
  /// 注意：成功後不會自動登出，呼叫端需在顯示成功訊息後手動呼叫 logout()
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (state == null) return false;

    final isSuccess = await _repository.changePassword(
      state!,
      oldPassword,
      newPassword,
    );

    // 不在這裡呼叫 logout()，讓 UI 先顯示成功 Dialog
    // 呼叫端需在 Dialog 確認後手動呼叫 logout()
    return isSuccess;
  }

  Future<bool> deleteAccount({
    required String password,
    required bool agreeToTerms,
    String? reasonId,
    List<String>? subReasonId,
    String? feedback,
  }) async {
    if (state == null) return false;

    try {
      await ref.read(bioProvider.notifier).deleteBiometricData();
    } catch (e) {
      log('Error deleting biometric data on account deletion: $e');
    }
    await ref
        .read(notificationRepositoryProvider)
        .unregisterNotifications();

    final isSuccess = await _repository.deleteAccount(
      state!,
      password,
      agreeToTerms: agreeToTerms,
      reasonId: reasonId,
      subReasonId: subReasonId,
      feedback: feedback,
    );
    if (isSuccess && ref.mounted) {
      state = null;
      ref.read(profileProvider.notifier).clear();
    }
    return isSuccess;
  }


}
