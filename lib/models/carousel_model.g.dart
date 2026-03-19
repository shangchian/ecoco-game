// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarouselModel _$CarouselModelFromJson(Map<String, dynamic> json) =>
    CarouselModel(
      id: json['id'] as String,
      placementKey: json['placementKey'] as String,
      title: json['title'] as String,
      promotionCode: json['promotionCode'] as String?,
      mediaType: json['mediaType'] as String,
      mediaUrl: json['mediaUrl'] as String,
      fallbackUrl: json['fallbackUrl'] as String?,
      actionType: json['actionType'] as String,
      actionLink: json['actionLink'] as String?,
      sortOrder: (json['sortOrder'] as num).toInt(),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt'] as String),
    );

Map<String, dynamic> _$CarouselModelToJson(CarouselModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placementKey': instance.placementKey,
      'title': instance.title,
      'promotionCode': instance.promotionCode,
      'mediaType': instance.mediaType,
      'mediaUrl': instance.mediaUrl,
      'fallbackUrl': instance.fallbackUrl,
      'actionType': instance.actionType,
      'actionLink': instance.actionLink,
      'sortOrder': instance.sortOrder,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'expiredAt': instance.expiredAt?.toIso8601String(),
    };
