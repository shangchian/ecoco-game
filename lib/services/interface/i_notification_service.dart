import '/models/notification_preferences.dart' as pref;
import '/models/notification_settings_model.dart' as app_models;
import '/models/notification_item_model.dart';

/// Interface for Notification Service
/// Implemented by both real and mock services
abstract class INotificationService {
  Future<app_models.NotificationSettings> getNotificationSettings();

  Future<void> updateNotificationSettings({
    required bool globalStatus,
    required Map<pref.NotificationType, bool> preferences,
    required String fcmToken,
  });

  Future<List<NotificationItemModel>> getPersonalNotifications();

  Future<void> reportReadStatus({
    required String id,
    required String type,
  });
}
