class RegisterValidator {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入手機號碼';
    }
    if (!RegExp(r'^09\d{8}$').hasMatch(value)) {
      return '請輸入正確的手機號碼格式';
    }
    return null;
  }

  static bool validatePhoneFormat(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    if (!RegExp(r'^09\d{8}$').hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入驗證碼';
    }
    if (value.length != 6) {
      return '驗證碼必須為6位英文數字';
    }
    return null;
  }
}