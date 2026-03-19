import 'package:json_annotation/json_annotation.dart';

part 'brand_model.g.dart';

/// JSON converter for couponRuleIds that handles both int and String types
class CouponRuleIdsJsonConverter extends JsonConverter<List<String>, List<dynamic>> {
  const CouponRuleIdsJsonConverter();

  @override
  List<String> fromJson(List<dynamic> json) {
    return json.map((e) => e.toString()).toList();
  }

  @override
  List<dynamic> toJson(List<String> object) {
    return object;
  }
}

/// Brand category enum matching API values
enum BrandCategory {
  @JsonValue('LIFESTYLE_RETAIL')
  lifestyleRetail,
  @JsonValue('FOOD_BEVERAGE')
  foodBeverage,
  @JsonValue('LEISURE_ENTERTAINMENT')
  leisureEntertainment,
  @JsonValue('HEALTH_FITNESS')
  healthFitness,
  @JsonValue('EDUCATION_CHARITY')
  educationCharity,
  @JsonValue('DIGITAL_TECHNOLOGY')
  digitalTechnology,
  @JsonValue('TRANSPORT_TRAVEL')
  transportTravel,
}

/// Extension for display names
extension BrandCategoryExtension on BrandCategory {
  String get displayName {
    switch (this) {
      case BrandCategory.lifestyleRetail:
        return '生活百貨';
      case BrandCategory.foodBeverage:
        return '餐飲美食';
      case BrandCategory.leisureEntertainment:
        return '休閒娛樂';
      case BrandCategory.healthFitness:
        return '健康運動';
      case BrandCategory.educationCharity:
        return '教育公益';
      case BrandCategory.digitalTechnology:
        return '數位科技';
      case BrandCategory.transportTravel:
        return '交通旅遊';
    }
  }
}

@JsonSerializable()
class Brand {
  final String id;
  final bool isActive;
  final String name;
  final BrandCategory? category;
  @JsonKey(name: 'logoUrl')
  final String? logoUrl;
  final bool isPremium;
  final DateTime startDate;
  final DateTime? endDate;
  final String? descriptionMdUrl;
  final int sortOrder;
  @CouponRuleIdsJsonConverter()
  final List<String> couponRuleIds;

  Brand({
    required this.id,
    required this.isActive,
    required this.name,
    this.category,
    this.logoUrl,
    required this.isPremium,
    required this.startDate,
    this.endDate,
    this.descriptionMdUrl,
    required this.sortOrder,
    required this.couponRuleIds,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
  Map<String, dynamic> toJson() => _$BrandToJson(this);

  /// Check if brand is currently in active campaign period
  bool get isInActivePeriod {
    final now = DateTime.now().toUtc();
    return startDate.isBefore(now) &&
        (endDate == null || endDate!.isAfter(now));
  }

  /// Check if brand should be displayed (active + in period + has category)
  bool get shouldDisplay => isActive && isInActivePeriod && category != null;

  /// Check if brand has coupons
  bool get hasCoupons => couponRuleIds.isNotEmpty;

  /// Get coupon count
  int get couponCount => couponRuleIds.length;
}
