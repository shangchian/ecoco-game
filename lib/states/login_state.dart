class LoginState {
  final String phone;
  final String password;
  final bool rememberMe;
  final bool useBiometric;
  final bool hasBiometric;
  final bool showPassword;

  LoginState({
    this.phone = '',
    this.password = '',
    this.rememberMe = false,
    this.useBiometric = false,
    this.showPassword = false,
    this.hasBiometric = false,
  });

  LoginState copyWith({
    String? phone,
    String? password,
    bool? rememberMe,
    bool? useBiometric,
    bool? showPassword,
    bool? hasBiometric,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      useBiometric: useBiometric ?? this.useBiometric,
      showPassword: showPassword ?? this.showPassword,
      hasBiometric: hasBiometric ?? this.hasBiometric,
    );
  }
}