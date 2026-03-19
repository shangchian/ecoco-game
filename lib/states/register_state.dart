import 'dart:io';

class RegisterState {
  final String phone;
  final String otp;
  final String password;
  final String confirmPassword;
  final String nickname;
  final String email;
  final String location;
  final String? gender;
  final DateTime? birthday;
  final bool subscribeNews;
  final bool agreeTerms;
  final bool isLoading;
  final String? areaId;
  final String? districtId;

  final File? photoFile;

  RegisterState({
    this.phone = '',
    this.otp = '',
    this.password = '',
    this.confirmPassword = '',
    this.nickname = '',
    this.email = '',
    this.location = '',
    this.gender,
    this.birthday,
    this.subscribeNews = false,
    this.agreeTerms = false,
    this.isLoading = false,
    this.areaId,
    this.districtId,
    this.photoFile,
  });

  RegisterState copyWith({
    String? phone,
    String? otp,
    String? password,
    String? confirmPassword,
    String? nickname,
    String? email,
    String? location,
    String? gender,
    DateTime? birthday,
    bool? subscribeNews,
    bool? agreeTerms,
    bool? isLoading,
    String? areaId,
    String? districtId,
    File? photoFile,
  }) {
    return RegisterState(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      subscribeNews: subscribeNews ?? this.subscribeNews,
      agreeTerms: agreeTerms ?? this.agreeTerms,
      isLoading: isLoading ?? this.isLoading,
      areaId: areaId ?? this.areaId,
      districtId: districtId ?? this.districtId,
      photoFile: photoFile ?? this.photoFile,
    );
  }
}