import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_product_model.freezed.dart';
part 'shop_product_model.g.dart';

enum ProductCurrencyType {
  iap,  // Real money purchase via in_app_purchase
  ecocoPoint // Exchange using ECOCO points
}

@freezed
abstract class ShopProductModel with _$ShopProductModel {
  const factory ShopProductModel({
    required String id,
    required String title,
    required String description,
    required ProductCurrencyType currencyType,
    int? ecocoPointCost, // Cost in ECOCO points (if applicable)
    String? iapPriceString, // Formatted localized price e.g. "NT$30" (if applicable)
    required int goldReward, // Amount of game gold rewarded upon purchase
    @Default(false) bool isAvailable,
  }) = _ShopProductModel;

  factory ShopProductModel.fromJson(Map<String, dynamic> json) => _$ShopProductModelFromJson(json);
}
