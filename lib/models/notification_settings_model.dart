import 'package:json_annotation/json_annotation.dart';

part 'notification_settings_model.g.dart';

@JsonSerializable()
class NotificationSettings {
  final bool status;
  final List<NotificationTypeSetting> typeSettings;

  NotificationSettings({
    required this.status,
    required this.typeSettings,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}

@JsonSerializable()
class NotificationTypeSetting {
  final String typeCode;
  final String typeName;
  final bool isEnabled;

  NotificationTypeSetting({
    required this.typeCode,
    required this.typeName,
    required this.isEnabled,
  });

  factory NotificationTypeSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationTypeSettingFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationTypeSettingToJson(this);
}
