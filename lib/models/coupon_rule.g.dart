// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponRule _$CouponRuleFromJson(Map<String, dynamic> json) => CouponRule(
  id: json['couponRuleId'] as String,
  isActive: json['isActive'] as bool,
  categoryCode: const CouponCategoryConverter().fromJson(
    json['categoryCode'] as String,
  ),
  title: json['title'] as String? ?? '',
  brandId: json['brandId'] as String? ?? '',
  brandName: json['brandName'] as String? ?? '',
  cardImageUrl: json['cardImageUrl'] as String?,
  donationCode: json['donationCode'] as String?,
  isPremium: json['isPremium'] as bool,
  promoLabel: json['promoteLabel'] as String?,
  shortNotice: json['shortNotice'] as String?,
  unitPrice: (json['unitPrice'] as num).toInt(),
  displayUnit: json['displayUnit'] as String? ?? '',
  currencyCode: $enumDecode(_$CurrencyCodeEnumMap, json['currencyCode']),
  exchangeDisplayText: json['exchangeDisplayText'] as String? ?? '',
  exchangeInputType: $enumDecode(
    _$ExchangeInputTypeEnumMap,
    json['exchangeInputType'],
  ),
  exchangeFlowType: $enumDecode(
    _$ExchangeFlowTypeEnumMap,
    json['exchangeFlowType'],
  ),
  assetRedeemType: $enumDecode(
    _$AssetRedeemTypeEnumMap,
    json['assetRedeemType'],
  ),
  maxPerExchangeCount: (json['maxPerExchangeCount'] as num?)?.toInt(),
  exchangeStepValue: (json['exchangeStepValue'] as num).toInt(),
  geofenceAreaIds: (json['geofenceAreaIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  exchangeableStartAt: DateTime.parse(json['exchangeableStartAt'] as String),
  exchangeableEndAt: json['exchangeableEndAt'] == null
      ? null
      : DateTime.parse(json['exchangeableEndAt'] as String),
  lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
  carouselList: (json['carouselList'] as List<dynamic>)
      .map((e) => CarouselItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  exchangeAlert: json['exchangeAlert'] as String?,
  externalRedemptionUrl: json['externalRedemptionUrl'] as String?,
  rulesSummaryMdUrl: json['rulesSummaryMdUrl'] as String? ?? '',
  redemptionTermsMdUrl: json['redemptionTermsMdUrl'] as String? ?? '',
  userInstructionMdUrl: json['userInstructionMdUrl'] as String?,
  staffInstructionMdUrl: json['staffInstructionMdUrl'] as String?,
  sortOrder: (json['sortOrder'] as num).toInt(),
);

Map<String, dynamic> _$CouponRuleToJson(
  CouponRule instance,
) => <String, dynamic>{
  'couponRuleId': instance.id,
  'isActive': instance.isActive,
  'categoryCode': const CouponCategoryConverter().toJson(instance.categoryCode),
  'title': instance.title,
  'brandId': instance.brandId,
  'brandName': instance.brandName,
  'cardImageUrl': instance.cardImageUrl,
  'donationCode': instance.donationCode,
  'isPremium': instance.isPremium,
  'promoteLabel': instance.promoLabel,
  'shortNotice': instance.shortNotice,
  'unitPrice': instance.unitPrice,
  'displayUnit': instance.displayUnit,
  'currencyCode': _$CurrencyCodeEnumMap[instance.currencyCode]!,
  'exchangeDisplayText': instance.exchangeDisplayText,
  'exchangeInputType': _$ExchangeInputTypeEnumMap[instance.exchangeInputType]!,
  'exchangeFlowType': _$ExchangeFlowTypeEnumMap[instance.exchangeFlowType]!,
  'assetRedeemType': _$AssetRedeemTypeEnumMap[instance.assetRedeemType]!,
  'maxPerExchangeCount': instance.maxPerExchangeCount,
  'exchangeStepValue': instance.exchangeStepValue,
  'geofenceAreaIds': instance.geofenceAreaIds,
  'exchangeableStartAt': instance.exchangeableStartAt.toIso8601String(),
  'exchangeableEndAt': instance.exchangeableEndAt?.toIso8601String(),
  'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
  'carouselList': instance.carouselList,
  'exchangeAlert': instance.exchangeAlert,
  'externalRedemptionUrl': instance.externalRedemptionUrl,
  'rulesSummaryMdUrl': instance.rulesSummaryMdUrl,
  'redemptionTermsMdUrl': instance.redemptionTermsMdUrl,
  'userInstructionMdUrl': instance.userInstructionMdUrl,
  'staffInstructionMdUrl': instance.staffInstructionMdUrl,
  'sortOrder': instance.sortOrder,
};

const _$CurrencyCodeEnumMap = {
  CurrencyCode.ecocoPoint: 'ECOCO_POINT',
  CurrencyCode.daka: 'DAKA',
  CurrencyCode.ntp: 'NEW_TAIPAY_POINT',
};

const _$ExchangeInputTypeEnumMap = {
  ExchangeInputType.quantityBased: 'QUANTITY_BASED',
  ExchangeInputType.amountDiscount: 'AMOUNT_DISCOUNT',
  ExchangeInputType.pointsConversion: 'POINTS_CONVERSION',
};

const _$ExchangeFlowTypeEnumMap = {
  ExchangeFlowType.directlyAvailableWallet: 'DIRECTLY_AVAILABLE_WALLET',
  ExchangeFlowType.branchCodeUsed: 'BRANCH_CODE_USED',
  ExchangeFlowType.branchCodeUsedDisplay: 'BRANCH_CODE_USED_DISPLAY',
  ExchangeFlowType.branchCodeAvailableWallet: 'BRANCH_CODE_AVAILABLE_WALLET',
  ExchangeFlowType.branchCodeAvailableDisplay: 'BRANCH_CODE_AVAILABLE_DISPLAY',
  ExchangeFlowType.posHolding: 'POS_HOLDING',
  ExchangeFlowType.directlyUsedDonation: 'DIRECTLY_USED_DONATION',
  ExchangeFlowType.unknown: '',
};

const _$AssetRedeemTypeEnumMap = {
  AssetRedeemType.scanToRedeem: 'SCAN_TO_REDEEM',
  AssetRedeemType.copyCode: 'COPY_CODE',
  AssetRedeemType.none: 'NONE',
};
