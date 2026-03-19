import 'dart:developer';
import '/models/notification_preferences.dart' as pref;
import '/models/notification_settings_model.dart' as app_models;
import '/models/notification_item_model.dart';
import '/services/interface/i_notification_service.dart';

class NotificationServiceMock implements INotificationService {
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<app_models.NotificationSettings> getNotificationSettings() async {
    await _simulateNetworkDelay();

    // Return mock notification settings with all types enabled by default
    return app_models.NotificationSettings(
      status: true,
      typeSettings: [
        app_models.NotificationTypeSetting(
          typeCode: 'ECOCO_ANNOUNCE',
          typeName: 'ECOCO公告',
          isEnabled: true,
        ),
        app_models.NotificationTypeSetting(
          typeCode: 'CAMPAIGN_NEWS',
          typeName: '最新活動',
          isEnabled: true,
        ),
        app_models.NotificationTypeSetting(
          typeCode: 'BRAND_PROMO',
          typeName: '商家優惠',
          isEnabled: true,
        ),
        app_models.NotificationTypeSetting(
          typeCode: 'POINT_EXPIRY',
          typeName: '點數到期提醒',
          isEnabled: true,
        ),
        app_models.NotificationTypeSetting(
          typeCode: 'COUPON_EXPIRY',
          typeName: '優惠券到期提醒',
          isEnabled: true,
        ),
      ],
    );
  }

  @override
  Future<void> updateNotificationSettings({
    required bool globalStatus,
    required Map<pref.NotificationType, bool> preferences,
    required String fcmToken,
  }) async {
    await _simulateNetworkDelay();

    if (fcmToken.isEmpty) {
      throw Exception('FCM token cannot be empty');
    }

    // Mock update - always succeeds
    // In a real implementation, this would update the server
  }

  @override
  Future<List<NotificationItemModel>> getPersonalNotifications() async {
    await _simulateNetworkDelay();
    return [
      NotificationItemModel(
        id: 'mock_personal_001',
        title: '【測試】您的點數即將到期',
        summary: '這是一則測試的歷史個人推播，代表您成功從 API 恢復了資料。',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        actionType: 'APP_PAGE',
        actionLink: 'ecoco://app/notifications?tab=personal',
      ),
    ];
  }

  @override
  Future<void> reportReadStatus({
    required String id,
    required String type,
  }) async {
    log('Mock: reportReadStatus called for $id ($type)');
    return Future.value();
  }
}
