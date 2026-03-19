class ForgetPasswordState {
  final int currentStep;
  final String phoneNumber;
  final String? serverVerificationCode;
  final String verificationCode;
  final String newPassword;
  final String confirmPassword;
  final DateTime? otpExpiresAt;
  final DateTime? resendAvailableAt;
  final String? resetToken;
  final DateTime? resetTokenExpiresAt;
  final String? memberId;

  const ForgetPasswordState({
    this.currentStep = 0,
    this.phoneNumber = '',
    this.verificationCode = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.serverVerificationCode,
    this.otpExpiresAt,
    this.resendAvailableAt,
    this.resetToken,
    this.resetTokenExpiresAt,
    this.memberId,
  });

  ForgetPasswordState copyWith({
    int? currentStep,
    String? phoneNumber,
    String? verificationCode,
    String? newPassword,
    String? confirmPassword,
    String? serverVerificationCode,
    DateTime? otpExpiresAt,
    DateTime? resendAvailableAt,
    String? resetToken,
    DateTime? resetTokenExpiresAt,
    String? memberId,
  }) {
    return ForgetPasswordState(
      currentStep: currentStep ?? this.currentStep,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationCode: verificationCode ?? this.verificationCode,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      serverVerificationCode: serverVerificationCode ?? this.serverVerificationCode,
      otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
      resendAvailableAt: resendAvailableAt ?? this.resendAvailableAt,
      resetToken: resetToken ?? this.resetToken,
      resetTokenExpiresAt: resetTokenExpiresAt ?? this.resetTokenExpiresAt,
      memberId: memberId ?? this.memberId,
    );
  }
}