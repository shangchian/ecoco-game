import 'package:drift/drift.dart' as drift;
import 'package:json_annotation/json_annotation.dart';
import '/database/converters/carousel_list_converter.dart';
import '/database/app_database.dart';
import '/models/coupon_status_model.dart';

part 'coupon_rule.g.dart';

/// Custom converter for CouponCategory to handle typos and variations
class CouponCategoryConverter implements JsonConverter<CouponCategory, String> {
  const CouponCategoryConverter();

  @override
  CouponCategory fromJson(String json) {
    // Normalize the input
    final normalized = json.toUpperCase().trim();

    // Handle typos and variations
    switch (normalized) {
      case 'SHOPPING':
        return CouponCategory.shopping;
      case 'FOOD':
        return CouponCategory.food;
      case 'LIFESTYLE':
      case 'LIFFSTYLE': // Handle common typo
        return CouponCategory.lifestyle;
      case 'RECREATION':
        return CouponCategory.recreation;
      case 'HEALTH':
        return CouponCategory.health;
      case 'CHARITY':
        return CouponCategory.charity;
      case 'POINTS_EXCHANGE':
        return CouponCategory.pointsExchange;
      case '':
        return CouponCategory.uncategorized;
      default:
        // Unknown values default to uncategorized
        return CouponCategory.uncategorized;
    }
  }

  @override
  String toJson(CouponCategory object) {
    switch (object) {
      case CouponCategory.shopping:
        return 'SHOPPING';
      case CouponCategory.food:
        return 'FOOD';
      case CouponCategory.lifestyle:
        return 'LIFESTYLE'; // Always output correct spelling
      case CouponCategory.recreation:
        return 'RECREATION';
      case CouponCategory.health:
        return 'HEALTH';
      case CouponCategory.charity:
        return 'CHARITY';
      case CouponCategory.pointsExchange:
        return 'POINTS_EXCHANGE';
      case CouponCategory.uncategorized:
        return '';
    }
  }
}

/// Coupon category enum matching API values
enum CouponCategory {
  shopping,
  food,
  lifestyle,
  recreation,
  health,
  charity,
  pointsExchange,
  uncategorized,
}

/// Extension for display names
extension CouponCategoryExtension on CouponCategory {
  String get displayName {
    switch (this) {
      case CouponCategory.shopping:
        return '購物';
      case CouponCategory.food:
        return '餐飲';
      case CouponCategory.lifestyle:
        return '生活';
      case CouponCategory.recreation:
        return '娛樂';
      case CouponCategory.health:
        return '健康';
      case CouponCategory.charity:
        return '公益';
      case CouponCategory.pointsExchange:
        return '點數';
      case CouponCategory.uncategorized:
        return '無分類';
    }
  }
}

/// Currency code enum
enum CurrencyCode {
  @JsonValue('ECOCO_POINT')
  ecocoPoint,
  @JsonValue('DAKA')
  daka,
  @JsonValue('NEW_TAIPAY_POINT')
  ntp,
}

/// Extension for display names
extension CurrencyCodeExtension on CurrencyCode {
  String get displayName {
    switch (this) {
      case CurrencyCode.ecocoPoint:
        return 'ecoco點數';
      case CurrencyCode.daka:
        return 'DAKA寶石幣';
      case CurrencyCode.ntp:
        return '新北幣';
    }
  }
}

/// Exchange input type enum
enum ExchangeInputType {
  @JsonValue('QUANTITY_BASED')
  quantityBased,
  @JsonValue('AMOUNT_DISCOUNT')
  amountDiscount,
  @JsonValue('POINTS_CONVERSION')
  pointsConversion,
}

/// Exchange flow type enum
enum ExchangeFlowType {
  @JsonValue('DIRECTLY_AVAILABLE_WALLET')
  directlyAvailableWallet,
  @JsonValue('BRANCH_CODE_USED')
  branchCodeUsed,
  @JsonValue('BRANCH_CODE_USED_DISPLAY')
  branchCodeUsedDisplay,
  @JsonValue('BRANCH_CODE_AVAILABLE_WALLET')
  branchCodeAvailableWallet,
  @JsonValue('BRANCH_CODE_AVAILABLE_DISPLAY')
  branchCodeAvailableDisplay,
  @JsonValue('POS_HOLDING')
  posHolding,
  @JsonValue('DIRECTLY_USED_DONATION')
  directlyUsedDonation,
  @JsonValue('')
  unknown,
}

/// Asset redeem type enum
enum AssetRedeemType {
  @JsonValue('SCAN_TO_REDEEM')
  scanToRedeem,
  @JsonValue('COPY_CODE')
  copyCode,
  @JsonValue('NONE')
  none,
}

/// Media type enum for carousel items
enum MediaType {
  @JsonValue('STATIC_IMAGE')
  staticImage,
  @JsonValue('LOOPING_ANIMATION')
  loopingAnimation,
  @JsonValue('LOTTIE')
  lottie,
  @JsonValue('VIDEO')
  video,
}

@JsonSerializable()
class CouponRule {
  @JsonKey(name: 'couponRuleId')
  final String id;
  final bool isActive;
  @CouponCategoryConverter()
  final CouponCategory categoryCode;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String brandId;
  @JsonKey(defaultValue: '')
  final String brandName;
  final String? cardImageUrl;
  final String? donationCode;
  final bool isPremium;
  @JsonKey(name: 'promoteLabel')
  final String? promoLabel;
  final String? shortNotice;
  final int unitPrice;
  @JsonKey(defaultValue: '')
  final String displayUnit;
  final CurrencyCode currencyCode;
  @JsonKey(defaultValue: '')
  final String exchangeDisplayText;
  final ExchangeInputType exchangeInputType;
  final ExchangeFlowType exchangeFlowType;
  final AssetRedeemType assetRedeemType;
  final int? maxPerExchangeCount;
  final int exchangeStepValue;
  final List<String> geofenceAreaIds;
  final DateTime exchangeableStartAt;
  final DateTime? exchangeableEndAt;
  final DateTime lastUpdatedAt;
  final List<CarouselItem> carouselList;
  final String? exchangeAlert;
  final String? externalRedemptionUrl;
  @JsonKey(defaultValue: '')
  final String rulesSummaryMdUrl;
  @JsonKey(defaultValue: '')
  final String redemptionTermsMdUrl;
  final String? userInstructionMdUrl;
  final String? staffInstructionMdUrl;
  final int sortOrder;

  // Runtime property for display status (not serialized to/from JSON)
  @JsonKey(includeFromJson: false, includeToJson: false)
  DisplayStatus displayStatus;

  CouponRule({
    required this.id,
    required this.isActive,
    required this.categoryCode,
    required this.title,
    required this.brandId,
    required this.brandName,
    this.cardImageUrl,
    this.donationCode,
    required this.isPremium,
    this.promoLabel,
    this.shortNotice,
    required this.unitPrice,
    required this.displayUnit,
    required this.currencyCode,
    required this.exchangeDisplayText,
    required this.exchangeInputType,
    required this.exchangeFlowType,
    required this.assetRedeemType,
    this.maxPerExchangeCount,
    required this.exchangeStepValue,
    required this.geofenceAreaIds,
    required this.exchangeableStartAt,
    this.exchangeableEndAt,
    required this.lastUpdatedAt,
    required this.carouselList,
    this.exchangeAlert,
    this.externalRedemptionUrl,
    required this.rulesSummaryMdUrl,
    required this.redemptionTermsMdUrl,
    this.userInstructionMdUrl,
    this.staffInstructionMdUrl,
    required this.sortOrder,
    this.displayStatus = DisplayStatus.discontinued,
  });

  factory CouponRule.fromJson(Map<String, dynamic> json) {
    // Manually handle type conversion for fields that might be int but expected as String
    if (json['couponRuleId'] is num) {
      json['couponRuleId'] = json['couponRuleId'].toString();
    }
    if (json['brandId'] is num) {
      json['brandId'] = json['brandId'].toString();
    }
    if (json['geofenceAreaIds'] is List) {
      json['geofenceAreaIds'] = (json['geofenceAreaIds'] as List)
          .map((e) => e.toString())
          .toList();
    }
    
    return _$CouponRuleFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CouponRuleToJson(this);

  /// Convert to Drift Companion for database insertion
  CouponRulesCompanion toTableCompanion() {
    return CouponRulesCompanion(
      id: drift.Value(id),
      isActive: drift.Value(isActive),
      categoryCode: drift.Value(categoryCode.name.toUpperCase()),
      title: drift.Value(title),
      brandId: drift.Value(brandId),
      brandName: drift.Value(brandName),
      cardImageUrl: drift.Value(cardImageUrl),
      donationCode: drift.Value(donationCode),
      isPremium: drift.Value(isPremium),
      promoLabel: drift.Value(promoLabel),
      shortNotice: drift.Value(shortNotice),
      unitPrice: drift.Value(unitPrice),
      displayUnit: drift.Value(displayUnit),
      currencyCode: drift.Value(currencyCode.name.toUpperCase()),
      exchangeDisplayText: drift.Value(exchangeDisplayText),
      exchangeInputType: drift.Value(exchangeInputType.name.toUpperCase()),
      exchangeFlowType: drift.Value(exchangeFlowType.name.toUpperCase()),
      assetRedeemType: drift.Value(assetRedeemType.name.toUpperCase()),
      maxPerExchangeCount: drift.Value(maxPerExchangeCount),
      exchangeStepValue: drift.Value(exchangeStepValue),
      geofenceAreaIds: drift.Value(geofenceAreaIds),
      exchangeableStartAt: drift.Value(exchangeableStartAt),
      exchangeableEndAt: drift.Value(exchangeableEndAt),
      lastUpdatedAt: drift.Value(lastUpdatedAt),
      carouselList: drift.Value(carouselList),
      exchangeAlert: drift.Value(exchangeAlert),
      externalRedemptionUrl: drift.Value(externalRedemptionUrl),
      rulesSummaryMdUrl: drift.Value(rulesSummaryMdUrl),
      redemptionTermsMdUrl: drift.Value(redemptionTermsMdUrl),
      userInstructionMdUrl: drift.Value(userInstructionMdUrl),
      staffInstructionMdUrl: drift.Value(staffInstructionMdUrl),
      sortOrder: drift.Value(sortOrder),
      cachedAt: drift.Value(DateTime.now()),
    );
  }

  /// Check if coupon is currently in active exchange period
  bool get isInActivePeriod {
    final now = DateTime.now().toUtc();
    return exchangeableStartAt.isBefore(now) &&
        (exchangeableEndAt == null || exchangeableEndAt!.isAfter(now));
  }

  /// Check if coupon should be displayed (active + in period)
  bool get shouldDisplay => isActive && isInActivePeriod;

  /// Check if coupon has carousel content
  bool get hasCarousel => carouselList.isNotEmpty;

  /// Get active carousel items (published and not expired)
  List<CarouselItem> get activeCarouselItems {
    final now = DateTime.now().toUtc();
    return carouselList
        .where((item) =>
            item.publishedAt.isBefore(now) &&
            (item.expiredAt == null || item.expiredAt!.isAfter(now)))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Check if exchange is quantity-based
  bool get isQuantityBased =>
      exchangeInputType == ExchangeInputType.quantityBased;

  /// Check if exchange is amount-based discount
  bool get isAmountDiscount =>
      exchangeInputType == ExchangeInputType.amountDiscount;

  /// Check if coupon goes directly to wallet
  bool get isDirectlyAvailable =>
      exchangeFlowType == ExchangeFlowType.directlyAvailableWallet;

  /// Check if coupon has active status (not discontinued)
  bool get hasActiveStatus => displayStatus != DisplayStatus.discontinued;

  /// Check if coupon is available for exchange (considering both rule and status)
  bool get isAvailableForExchange => shouldDisplay && displayStatus.isAvailable;

  /// Check if coupon is sold out
  bool get isSoldOut => displayStatus == DisplayStatus.soldOut;
}
