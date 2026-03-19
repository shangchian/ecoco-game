import 'dart:io';

import '/models/district_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/states/register_state.dart';

part 'register_provider.g.dart';

@Riverpod(keepAlive: true)
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() => RegisterState();

  // 手機號碼驗證
  bool validatePhone(String phone) {
    return phone.length == 10 && phone.startsWith('09');
  }

  // OTP驗證
  bool validateOTP(String otp) {
    return otp.length == 6;
  }

  // 密碼驗證
  bool validatePassword(String password) {
    // 密碼需包含英文字母及數字，長度8-20個英數字
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final validLength = password.length >= 8 && password.length <= 20;
    return hasLetter && hasNumber && hasSpecialChar && validLength;
  }

  // 確認密碼驗證
  bool validateConfirmPassword() {
    return state.password == state.confirmPassword;
  }

  // Email驗證
  bool validateEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Add new validation method for nickname
  bool validateNickname(String nickname) {
    return nickname.length >= 2 && nickname.length <= 20;
  }

  // Add method to validate all fields
  bool validateAllFields() {
    return validatePhone(state.phone) &&
        validatePassword(state.password) &&
        validateConfirmPassword() &&
        validateEmail(state.email) &&
        validateNickname(state.nickname) &&
        (state.agreeTerms);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updateOTP(String otp) {
    state = state.copyWith(otp: otp);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void updateProfile({
    String? nickname,
    String? email,
    String? location,
    String? gender,
    DateTime? birthday,
    bool? subscribeNews,
    bool? agreeTerms,
    DistrictModel? district,
  }) {
    state = state.copyWith(
      nickname: nickname ?? state.nickname,
      email: email ?? state.email,
      location: location ?? state.location,
      gender: gender ?? state.gender,
      birthday: birthday ?? state.birthday,
      subscribeNews: subscribeNews ?? state.subscribeNews,
      agreeTerms: agreeTerms ?? state.agreeTerms,
      areaId: district != null ? district.areaId.toString() : state.areaId,
      districtId: district != null ? district.districtId.toString() : state.districtId,
    );
  }

  void requestOTP() {}

  void updateBirthday(DateTime picked) {
    state = state.copyWith(birthday: picked);
  }

  void updateNickname(String value) {
    state = state.copyWith(nickname: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateGender(String? value) {
    state = state.copyWith(gender: value);
  }

  void updateLocation(DistrictModel? value) {
    state = state.copyWith(
      areaId: value?.areaId.toString(),
      districtId: value?.districtId.toString(),
    );
  }

  void updateSubscribeNews(bool bool) {
    state = state.copyWith(subscribeNews: bool);
  }

  void register() {}

  void updatePhoto(File? photo) {
    state = state.copyWith(photoFile: photo);
  }
}
