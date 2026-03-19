/// Utility functions for phone number formatting and display
class PhoneUtils {
  /// Returns the last 4 digits of a phone number.
  /// If the phone number has 4 or fewer digits, returns the full number.
  /// Returns empty string if phone is null or empty.
  ///
  /// Examples:
  /// - "0912345678" -> "5678"
  /// - "123" -> "123"
  /// - null -> ""
  static String getLastFourDigits(String? phone) {
    if (phone == null || phone.isEmpty) return "";
    return phone.length <= 4 ? phone : phone.substring(phone.length - 4);
  }
}
