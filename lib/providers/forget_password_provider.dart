import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../states/forget_password_state.dart';
import '/models/send_otp_response_model.dart';

part 'forget_password_provider.g.dart';

@riverpod
class ForgetPasswordController extends _$ForgetPasswordController {
  @override
  ForgetPasswordState build() => const ForgetPasswordState();

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void updatePhoneNumber(String phone) {
    state = state.copyWith(phoneNumber: phone);
  }

  String parserPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 4)}-${phone.substring(4, 7)}-${phone.substring(7)}';
    }
    return phone;
  }

  void updateVerificationCode(String code) {
    state = state.copyWith(verificationCode: code);
  }

  void updateNewPassword(String password) {
    state = state.copyWith(newPassword: password);
  }

  void updateConfirmPassword(String password) {
    state = state.copyWith(confirmPassword: password);
  }

  void updateServerVerificationCode(String code) {
    state = state.copyWith(serverVerificationCode: code);
  }

  void updateOtpResponse(SendOtpResponse response) {
    state = state.copyWith(
      otpExpiresAt: response.otpExpiresAt,
      resendAvailableAt: response.resendAvailableAt,
    );
  }

  void updateResetToken(String token, DateTime expiresAt, String memberId) {
    state = state.copyWith(
      resetToken: token,
      resetTokenExpiresAt: expiresAt,
      memberId: memberId,
    );
  }

  void clearResetToken() {
    state = state.copyWith(
      resetToken: null,
      resetTokenExpiresAt: null,
      memberId: null,
    );
  }

  void reset() {
    state = const ForgetPasswordState();
  }
} 
