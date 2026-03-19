import 'package:json_annotation/json_annotation.dart';

part 'recycling_stats_response.g.dart';

/// Custom converter to handle String or num to double conversion
class DoubleConverter implements JsonConverter<double, dynamic> {
  const DoubleConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) return 0.0;

    if (json is num) {
      return json.toDouble();
    }

    if (json is String) {
      try {
        return double.parse(json);
      } catch (e) {
        // If parsing fails, return 0.0 as default
        return 0.0;
      }
    }

    // For any other type, return 0.0 as fallback
    return 0.0;
  }

  @override
  double toJson(double value) => value;
}

/// Custom converter to handle String or num to int conversion
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic json) {
    if (json == null) return 0;

    if (json is num) {
      return json.toInt();
    }

    if (json is String) {
      try {
        return int.parse(json);
      } catch (e) {
        // If parsing fails, return 0 as default
        return 0;
      }
    }

    // For any other type, return 0 as fallback
    return 0;
  }

  @override
  int toJson(int value) => value;
}

/// API response model for /member/recycling/stats endpoint
@JsonSerializable()
class RecyclingStatsResponse {
  final CarbonMetrics carbonMetrics;
  final List<RecyclingItem> itemList;

  const RecyclingStatsResponse({
    required this.carbonMetrics,
    required this.itemList,
  });

  factory RecyclingStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecyclingStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecyclingStatsResponseToJson(this);
}

/// Carbon reduction metrics in grams
@JsonSerializable()
class CarbonMetrics {
  @DoubleConverter()
  final double totalCarbonReduction; // 總減碳量 (grams)
  @DoubleConverter()
  final double monthlyCarbonReduction; // 本月減碳量 (grams)
  @DoubleConverter()
  final double annualCarbonReduction; // 年度減碳量 (grams)

  const CarbonMetrics({
    required this.totalCarbonReduction,
    required this.monthlyCarbonReduction,
    required this.annualCarbonReduction,
  });

  // Getters for KG conversion (UI displays in KG)
  double get totalCO2KG => totalCarbonReduction / 1000;
  double get monthlyCO2KG => monthlyCarbonReduction / 1000;
  double get annualCO2KG => annualCarbonReduction / 1000;

  factory CarbonMetrics.fromJson(Map<String, dynamic> json) =>
      _$CarbonMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$CarbonMetricsToJson(this);
}

/// Individual recycling item with period-specific counts
@JsonSerializable()
class RecyclingItem {
  final String itemCode; // "PET_BOTTLE", "PP_CUP", etc.
  final String itemName; // "寶特瓶", "PP塑膠杯", etc.
  @IntConverter()
  final int totalCount; // 總累計
  @IntConverter()
  final int? countThisYear; // 今年 (nullable for backward compatibility)
  @IntConverter()
  final int? countThisMonth; // 本月 (nullable for backward compatibility)

  const RecyclingItem({
    required this.itemCode,
    required this.itemName,
    required this.totalCount,
    this.countThisYear,
    this.countThisMonth,
  });

  factory RecyclingItem.fromJson(Map<String, dynamic> json) =>
      _$RecyclingItemFromJson(json);

  Map<String, dynamic> toJson() => _$RecyclingItemToJson(this);
}
