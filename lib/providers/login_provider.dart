// 建立一個 LoginNotifier, LoginProvider 來處理登入的邏輯
// 裡面要有 Phone 和 Password 的 State, 和 updatePhone 和 updatePassword 的 function

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/states/login_state.dart';

part 'login_provider.g.dart';

// 修改 LoginNotifier 來使用 LoginState
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => LoginState();

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void toggleBiometric() {
    state = state.copyWith(useBiometric: !state.useBiometric);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void updateHasBiometric(bool hasBiometric) {
    state = state.copyWith(hasBiometric: hasBiometric);
  }
}
