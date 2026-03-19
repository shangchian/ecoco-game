import 'package:json_annotation/json_annotation.dart';
import '/models/site_status_model.dart';

part 'site_model.g.dart';

/// Site types for different recycling machine categories
enum SiteType {
  @JsonValue('GROUPED_BIN')
  groupedBin, // AI機站點、方舟站，為了能秀可投遞數量
  @JsonValue('SEPARATE_BIN')
  separateBin, // H30機台、集過來，秀不出可投遞數量
}

/// Recyclable item types supported by sites
enum RecyclableItemType {
  @JsonValue('PET_BOTTLE')
  petBottle,
  @JsonValue('ALUMINUM_CAN')
  aluminumCan,
  @JsonValue('PP_CUP')
  ppCup,
  @JsonValue('HDPE_BOTTLE')
  hdpeBottle,
  @JsonValue('BATTERY')
  battery,
}

/// Custom converter for SiteType with default value fallback
class SiteTypeConverter implements JsonConverter<SiteType, String?> {
  const SiteTypeConverter();

  @override
  SiteType fromJson(String? json) {
    if (json == null) return SiteType.groupedBin;

    switch (json.toUpperCase()) {
      case 'GROUPED_BIN':
        return SiteType.groupedBin;
      case 'SEPARATE_BIN':
        return SiteType.separateBin;
      default:
        // 無法識別時預設為 groupedBin
        return SiteType.groupedBin;
    }
  }

  @override
  String toJson(SiteType type) {
    switch (type) {
      case SiteType.groupedBin:
        return 'GROUPED_BIN';
      case SiteType.separateBin:
        return 'SEPARATE_BIN';
    }
  }
}

@JsonSerializable(includeIfNull: true)
class Site {
  final String id;
  final String code;
  final String name;
  @SiteTypeConverter()
  final SiteType type;
  final String address;
  final double longitude;
  final double latitude;
  @JsonKey(name: 'serviceHours')
  final String serviceHours;
  @JsonKey(name: 'areaId')
  final String areaId;
  @JsonKey(name: 'districtId')
  final String districtId;
  final String? note;
  @JsonKey(name: 'recyclableItems')
  final List<RecyclableItemType> recyclableItems;

  // These fields come from status API, not from site data
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? statusUpdatedAt;

  // Rich status data from API (new)
  @JsonKey(includeFromJson: false, includeToJson: false)
  SiteStatus? statusData;

  // Computed from local storage
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool favorite;

  // Indicates if status fetch succeeded
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool statusAvailable;

  // Distance from user location (computed)
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? distance;

  Site({
    required this.id,
    required this.code,
    required this.name,
    this.type = SiteType.groupedBin,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.serviceHours,
    required this.areaId,
    required this.districtId,
    this.note,
    required this.recyclableItems,
    this.status,
    this.statusUpdatedAt,
    this.statusData,
    this.statusAvailable = false,
    this.favorite = false,
    this.distance,
  });

  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);

  Map<String, dynamic> toJson() => _$SiteToJson(this);

  /// Check if site is currently open
  /// Returns true if status shows open, or if status unavailable (show all sites)
  bool get isOpen {
    // If status data available, use it
    if (statusData != null) {
      return statusData!.displayStatus == 'NORMAL' &&
             !(statusData!.isOffHours ?? false);
    }
    // If legacy status available, use it
    if (status != null) {
      return status!.toLowerCase() == 'up';
    }
    // Status unavailable - show as neutral/available for gray indicators
    return true;
  }

  /// Check if site can accept items (可投)
  /// Returns true only if site is open AND has at least one bin with available space
  bool get canAcceptItems {
    // 1. Check specific status data if available
    if (statusData != null) {
      // Must be NORMAL and NOT off-hours
      final isOperational = statusData!.displayStatus == 'NORMAL' &&
          !(statusData!.isOffHours ?? false);

      if (!isOperational) return false;

      // 過濾掉維護中
      if (statusData!.areAllItemsDown == true) {
        return false;
      }

      // areAllItemsDown 判斷後，非 null、非 empty，且不全為 DOWN，代表至少有一個是 UP
      return true;
    }

    // 2. Check legacy status if available
    if (status != null) {
      return status!.toLowerCase() == 'up';
    }

    // 3. No status information -> Assume NOT available
    return false;
  }

  /// Check if site is grouped bin type (can show available quantity)
  bool get isGroupedBin => type == SiteType.groupedBin;

  /// Get longitude as double (already double, but for compatibility)
  double get longitudeAsDouble => longitude;

  /// Get latitude as double (already double, but for compatibility)
  double get latitudeAsDouble => latitude;
}
