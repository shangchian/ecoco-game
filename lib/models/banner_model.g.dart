// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
  id: json['id'] as String,
  imageUrl: json['image_url'] as String,
  title: json['title'] as String?,
  linkUrl: json['link_url'] as String?,
  displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
);

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'title': instance.title,
      'link_url': instance.linkUrl,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
    };
