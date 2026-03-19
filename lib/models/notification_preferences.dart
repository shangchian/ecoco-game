import 'package:json_annotation/json_annotation.dart';


part 'notification_preferences.g.dart';

enum NotificationType {
  announcement,
  activityInfo,
  merchantOffers,
  pointsExpiry,
  voucherExpiry,
}

extension NotificationTypeExtension on NotificationType {
  String get typeCode {
    switch (this) {
      case NotificationType.announcement:
        return 'ECOCO_ANNOUNCE';
      case NotificationType.activityInfo:
        return 'CAMPAIGN_NEWS';
      case NotificationType.merchantOffers:
        return 'BRAND_PROMO';
      case NotificationType.pointsExpiry:
        return 'POINT_EXPIRY';
      case NotificationType.voucherExpiry:
        return 'COUPON_EXPIRY';
    }
  }

  static NotificationType? fromTypeCode(String typeCode) {
    switch (typeCode) {
      case 'ECOCO_ANNOUNCE':
        return NotificationType.announcement;
      case 'CAMPAIGN_NEWS':
        return NotificationType.activityInfo;
      case 'BRAND_PROMO':
        return NotificationType.merchantOffers;
      case 'POINT_EXPIRY':
        return NotificationType.pointsExpiry;
      case 'COUPON_EXPIRY':
        return NotificationType.voucherExpiry;
      default:
        return null;
    }
  }
}

enum EmailType {
  activity,
  survey,
}

@JsonSerializable()
class NotificationPreferences {
  @JsonKey(fromJson: _notificationsFromJson, toJson: _notificationsToJson)
  final Map<NotificationType, bool> notifications;
  
  @JsonKey(fromJson: _emailsFromJson, toJson: _emailsToJson)
  final Map<EmailType, bool> emails;
  
  NotificationPreferences({
    Map<NotificationType, bool>? notifications,
    Map<EmailType, bool>? emails,
  }) : 
    notifications = notifications ?? Map.fromEntries(
      NotificationType.values.map((type) => MapEntry(type, false))
    ),
    emails = emails ?? Map.fromEntries(
      EmailType.values.map((type) => MapEntry(type, false))
    );
  
  static NotificationPreferences defaultPreferences() {
    return NotificationPreferences(
      notifications: Map.fromEntries(
        NotificationType.values.map((type) => MapEntry(type, true))
      ),
      emails: Map.fromEntries(
        EmailType.values.map((type) => MapEntry(type, true))
      ),
    );
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) => 
      _$NotificationPreferencesFromJson(json);
  
  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);

  static Map<NotificationType, bool> _notificationsFromJson(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(
      NotificationType.values.firstWhere((e) => e.name == key),
      value as bool,
    ));
  }

  static Map<String, dynamic> _notificationsToJson(Map<NotificationType, bool> notifications) {
    return notifications.map((key, value) => MapEntry(key.name, value));
  }

  static Map<EmailType, bool> _emailsFromJson(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(
      EmailType.values.firstWhere((e) => e.name == key),
      value as bool,
    ));
  }

  static Map<String, dynamic> _emailsToJson(Map<EmailType, bool> emails) {
    return emails.map((key, value) => MapEntry(key.name, value));
  }
} 