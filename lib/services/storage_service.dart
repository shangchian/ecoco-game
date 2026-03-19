import '/repositories/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/models/notification_preferences.dart';

class TokenData {
  final String? token;
  final NotificationPreferences preferences;

  TokenData({
    this.token,
    NotificationPreferences? preferences,
  }) : preferences =
            preferences ?? NotificationPreferences.defaultPreferences();
}

class StorageService {
  Future<TokenData> getTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationDataString =
        prefs.getString(NotificationRepository.notificationDataKey);

    return TokenData(
      token: prefs.getString(NotificationRepository.fcmTokenKey),
      preferences: notificationDataString != null
          ? NotificationPreferences.fromJson(jsonDecode(notificationDataString))
          : null,
    );
  }

  Future<void> saveTokenData({
    String? fcmToken,
    NotificationPreferences? preferences,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (fcmToken != null && fcmToken.isNotEmpty) {
      await prefs.setString(NotificationRepository.fcmTokenKey, fcmToken);
    }

    if (preferences != null) {
      await prefs.setString(NotificationRepository.notificationDataKey,
          jsonEncode(preferences.toJson()));
    }
  }

  Future<void> clearTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(NotificationRepository.fcmTokenKey);
    await prefs.remove(NotificationRepository.notificationDataKey);
  }

  Future<NotificationPreferences> getNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationDataString =
        prefs.getString(NotificationRepository.notificationDataKey);

    if (notificationDataString == null) {
      return NotificationPreferences.defaultPreferences();
    }

    return NotificationPreferences.fromJson(jsonDecode(notificationDataString));
  }

  Future<void> saveNotificationPreferences(
      NotificationPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(NotificationRepository.notificationDataKey,
        jsonEncode(preferences.toJson()));

    // Mark as initialized when saved
    await markNotificationPreferencesInitialized();
  }

  // Notification preferences initialization tracking
  static const String _notificationPreferencesInitializedKey = 'notification_preferences_initialized';

  Future<bool> hasNotificationPreferencesInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPreferencesInitializedKey) ?? false;
  }

  Future<void> markNotificationPreferencesInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPreferencesInitializedKey, true);
  }

  // Mock notification state management
  static const String _mockNotificationEnabledKey = 'mock_notification_enabled';

  Future<bool> getMockNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_mockNotificationEnabledKey) ?? false;
  }

  Future<void> saveMockNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mockNotificationEnabledKey, enabled);
  }

  Future<void> clearMockNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mockNotificationEnabledKey);
  }

  // Remember Me functionality
  static const String _rememberedPhoneKey = 'remembered_phone';

  /// 保存記住的手機號碼
  Future<void> saveRememberedPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rememberedPhoneKey, phone);
  }

  /// 獲取記住的手機號碼
  Future<String?> getRememberedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberedPhoneKey);
  }

  /// 清除記住的手機號碼
  Future<void> clearRememberedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberedPhoneKey);
  }
}
