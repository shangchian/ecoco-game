import 'package:json_annotation/json_annotation.dart';

part 'points_log_model.g.dart';

/// Log type enum for points transactions
enum LogType {
  @JsonValue("EARNED")
  earned,
  @JsonValue("USED")
  used,
}

/// Icon type code enum for different transaction sources
enum IconTypeCode {
  @JsonValue("BOTTLE")
  bottle,
  @JsonValue("BATTERY")
  battery,
  @JsonValue("SPECIAL_TOKEN")
  specialToken,
  @JsonValue("FBC")
  fbc,
  @JsonValue("SYSTEM_ADD")
  systemAdd,
  @JsonValue("SYSTEM_DEDUCT")
  systemDeduct,
  @JsonValue("COUPON_REDEEM")
  couponRedeem,
  @JsonValue("COUPON_REFUND")
  couponRefund,
  @JsonValue("CODE_REDEEM")
  codeRedeem,
  @JsonValue("CAMPAIGN")
  campaign,
  @JsonValue("POINTS_EXCHANGE_IN")
  pointsExchangeIn,
  @JsonValue("POINTS_EXCHANGE_OUT")
  pointsExchangeOut,
}

/// Detail type enum indicating the structure of details field
enum DetailType {
  @JsonValue("DETAILED_LIST")
  detailedList,
  @JsonValue("TEXT_DESCRIPTION")
  textDescription,
  @JsonValue("NONE")
  none,
}

/// Detail item for DETAILED_LIST type
@JsonSerializable(includeIfNull: true)
class DetailItem {
  final String name;
  final int? quantity;
  final int points;

  const DetailItem({
    required this.name,
    this.quantity,
    required this.points,
  });

  factory DetailItem.fromJson(Map<String, dynamic> json) =>
      _$DetailItemFromJson(json);

  Map<String, dynamic> toJson() => _$DetailItemToJson(this);
}

/// Main point log model representing a single points transaction
@JsonSerializable(includeIfNull: true)
class PointLog {
  final String logId;
  final LogType logType;
  final IconTypeCode iconTypeCode;
  final String currencyCode;
  @JsonKey(defaultValue: '')
  final String title;
  final String? labelText;
  final String? labelColor;
  final int pointsChange;
  final String occurredAt;
  final DetailType detailType;

  /// Raw details map - structure depends on detailType
  @JsonKey(name: 'details')
  final Map<String, dynamic>? detailsRaw;

  final String lastUpdatedAt;

  const PointLog({
    required this.logId,
    required this.logType,
    required this.iconTypeCode,
    required this.currencyCode,
    required this.title,
    this.labelText,
    this.labelColor,
    required this.pointsChange,
    required this.occurredAt,
    required this.detailType,
    this.detailsRaw,
    required this.lastUpdatedAt,
  });

  factory PointLog.fromJson(Map<String, dynamic> json) =>
      _$PointLogFromJson(json);

  Map<String, dynamic> toJson() => _$PointLogToJson(this);

  /// Type-safe getter for detail items (when detailType is DETAILED_LIST)
  List<DetailItem>? get detailItems {
    if (detailType != DetailType.detailedList || detailsRaw == null) {
      return null;
    }

    final items = detailsRaw!['items'];
    if (items is! List) return null;

    try {
      return items
          .map((e) => DetailItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Type-safe getter for text description (when detailType is TEXT_DESCRIPTION)
  String? get textDescription {
    if (detailType != DetailType.textDescription || detailsRaw == null) {
      return null;
    }

    return detailsRaw!['description'] as String?;
  }
}

/// API response wrapper for points history endpoint
@JsonSerializable(includeIfNull: true)
class PointsHistoryResponse {
  final List<PointLog> pointLogs;

  const PointsHistoryResponse({
    required this.pointLogs,
  });

  factory PointsHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PointsHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PointsHistoryResponseToJson(this);
}
