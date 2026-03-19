// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShopProductModel _$ShopProductModelFromJson(Map<String, dynamic> json) =>
    _ShopProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      currencyType: $enumDecode(
        _$ProductCurrencyTypeEnumMap,
        json['currencyType'],
      ),
      ecocoPointCost: (json['ecocoPointCost'] as num?)?.toInt(),
      iapPriceString: json['iapPriceString'] as String?,
      goldReward: (json['goldReward'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool? ?? false,
    );

Map<String, dynamic> _$ShopProductModelToJson(_ShopProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'currencyType': _$ProductCurrencyTypeEnumMap[instance.currencyType]!,
      'ecocoPointCost': instance.ecocoPointCost,
      'iapPriceString': instance.iapPriceString,
      'goldReward': instance.goldReward,
      'isAvailable': instance.isAvailable,
    };

const _$ProductCurrencyTypeEnumMap = {
  ProductCurrencyType.iap: 'iap',
  ProductCurrencyType.ecocoPoint: 'ecocoPoint',
};
