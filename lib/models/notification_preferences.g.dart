// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => NotificationPreferences(
  notifications: NotificationPreferences._notificationsFromJson(
    json['notifications'] as Map<String, dynamic>,
  ),
  emails: NotificationPreferences._emailsFromJson(
    json['emails'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  NotificationPreferences instance,
) => <String, dynamic>{
  'notifications': NotificationPreferences._notificationsToJson(
    instance.notifications,
  ),
  'emails': NotificationPreferences._emailsToJson(instance.emails),
};
