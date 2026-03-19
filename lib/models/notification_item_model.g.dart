// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationItemModel _$NotificationItemModelFromJson(
  Map<String, dynamic> json,
) => NotificationItemModel(
  id: json['id'] as String,
  title: json['title'] as String,
  tagText: json['tagText'] as String?,
  summary: json['summary'] as String,
  publishedAt: DateTime.parse(json['publishedAt'] as String),
  expiredAt: json['expiredAt'] == null
      ? null
      : DateTime.parse(json['expiredAt'] as String),
  actionType: json['actionType'] as String,
  actionLink: json['actionLink'] as String?,
);

Map<String, dynamic> _$NotificationItemModelToJson(
  NotificationItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'tagText': instance.tagText,
  'summary': instance.summary,
  'publishedAt': instance.publishedAt.toIso8601String(),
  'expiredAt': instance.expiredAt?.toIso8601String(),
  'actionType': instance.actionType,
  'actionLink': instance.actionLink,
};
