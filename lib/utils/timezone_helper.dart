import 'package:timezone/timezone.dart' as tz;

class TimezoneHelper {
  static const String taiwanTimezone = 'Asia/Taipei';

  /// 獲取當前台北時區日期 (YYYY-MM-DD 格式)
  static String getTaiwanDateString() {
    final location = tz.getLocation(taiwanTimezone);
    final now = tz.TZDateTime.now(location);
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 檢查儲存的日期是否與當前台北日期相同
  static bool isSameDate(String storedDate) {
    return storedDate == getTaiwanDateString();
  }
}
