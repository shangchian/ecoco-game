// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => NotificationSettings(
  status: json['status'] as bool,
  typeSettings: (json['typeSettings'] as List<dynamic>)
      .map((e) => NotificationTypeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'status': instance.status,
  'typeSettings': instance.typeSettings,
};

NotificationTypeSetting _$NotificationTypeSettingFromJson(
  Map<String, dynamic> json,
) => NotificationTypeSetting(
  typeCode: json['typeCode'] as String,
  typeName: json['typeName'] as String,
  isEnabled: json['isEnabled'] as bool,
);

Map<String, dynamic> _$NotificationTypeSettingToJson(
  NotificationTypeSetting instance,
) => <String, dynamic>{
  'typeCode': instance.typeCode,
  'typeName': instance.typeName,
  'isEnabled': instance.isEnabled,
};
