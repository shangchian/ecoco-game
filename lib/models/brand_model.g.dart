// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
  id: json['id'] as String,
  isActive: json['isActive'] as bool,
  name: json['name'] as String,
  category: $enumDecodeNullable(_$BrandCategoryEnumMap, json['category']),
  logoUrl: json['logoUrl'] as String?,
  isPremium: json['isPremium'] as bool,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  descriptionMdUrl: json['descriptionMdUrl'] as String?,
  sortOrder: (json['sortOrder'] as num).toInt(),
  couponRuleIds: const CouponRuleIdsJsonConverter().fromJson(
    json['couponRuleIds'] as List,
  ),
);

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
  'id': instance.id,
  'isActive': instance.isActive,
  'name': instance.name,
  'category': _$BrandCategoryEnumMap[instance.category],
  'logoUrl': instance.logoUrl,
  'isPremium': instance.isPremium,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'descriptionMdUrl': instance.descriptionMdUrl,
  'sortOrder': instance.sortOrder,
  'couponRuleIds': const CouponRuleIdsJsonConverter().toJson(
    instance.couponRuleIds,
  ),
};

const _$BrandCategoryEnumMap = {
  BrandCategory.lifestyleRetail: 'LIFESTYLE_RETAIL',
  BrandCategory.foodBeverage: 'FOOD_BEVERAGE',
  BrandCategory.leisureEntertainment: 'LEISURE_ENTERTAINMENT',
  BrandCategory.healthFitness: 'HEALTH_FITNESS',
  BrandCategory.educationCharity: 'EDUCATION_CHARITY',
  BrandCategory.digitalTechnology: 'DIGITAL_TECHNOLOGY',
  BrandCategory.transportTravel: 'TRANSPORT_TRAVEL',
};
