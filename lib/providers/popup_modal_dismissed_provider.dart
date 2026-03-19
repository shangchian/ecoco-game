import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'popup_modal_dismissed_provider.g.dart';

/// 取得台灣時間的日期字串 (YYYY-MM-DD)
String _getTaiwanDateString() {
  final taiwanTime = DateTime.now().toUtc().add(const Duration(hours: 8));
  return '${taiwanTime.year}-${taiwanTime.month.toString().padLeft(2, '0')}-${taiwanTime.day.toString().padLeft(2, '0')}';
}

/// Provider 管理「今日不再顯示」彈窗狀態
/// 使用 SharedPreferences 儲存今日是否已勾選不再顯示
@Riverpod(keepAlive: true)
class PopupModalDismissed extends _$PopupModalDismissed {
  static const _key = 'popup_modal_dismissed_date';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedDate = prefs.getString(_key);
    final todayDate = _getTaiwanDateString();

    // 檢查儲存的日期是否為今天（台灣時間）
    return dismissedDate == todayDate;
  }

  /// 標記今日不再顯示
  Future<void> dismissForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final todayDate = _getTaiwanDateString();
    await prefs.setString(_key, todayDate);
    state = const AsyncData(true);
  }
}
