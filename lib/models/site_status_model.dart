import 'package:json_annotation/json_annotation.dart';

part 'site_status_model.g.dart';

/// Item status model for recyclable items at a site
@JsonSerializable()
class ItemStatus {
  @JsonKey(name: 'itemCode')
  final String itemCode;
  final String status; // "UP" or "DOWN"
  @JsonKey(name: 'linkedBinCode')
  final String? linkedBinCode;

  ItemStatus({
    required this.itemCode,
    required this.status,
    this.linkedBinCode,
  });

  factory ItemStatus.fromJson(Map<String, dynamic> json) =>
      _$ItemStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ItemStatusToJson(this);
}

/// Bin status model for recycling bin capacity at a site
@JsonSerializable()
class BinStatus {
  @JsonKey(name: 'binCode')
  final String binCode;
  @JsonKey(name: 'availableCount')
  final int availableCount;

  BinStatus({
    required this.binCode,
    required this.availableCount,
  });

  factory BinStatus.fromJson(Map<String, dynamic> json) =>
      _$BinStatusFromJson(json);

  Map<String, dynamic> toJson() => _$BinStatusToJson(this);
}

/// Site status model with rich data from status API
@JsonSerializable()
class SiteStatus {
  @JsonKey(name: 'siteId')
  final String siteId;
  @JsonKey(name: 'displayStatus')
  final String displayStatus; // NORMAL, SUSPENDED, COOPERATION_ENDED, HIDDEN
  @JsonKey(name: 'cardType')
  final String? cardType; // GROUPED_BIN, SEPARATE_BIN
  @JsonKey(name: 'isOffHours')
  final bool? isOffHours;
  @JsonKey(name: 'itemStatusList')
  final List<ItemStatus>? itemStatusList;
  @JsonKey(name: 'binStatusList')
  final List<BinStatus>? binStatusList;

  SiteStatus({
    required this.siteId,
    required this.displayStatus,
    this.cardType,
    this.isOffHours,
    this.itemStatusList,
    this.binStatusList,
  });

  factory SiteStatus.fromJson(Map<String, dynamic> json) =>
      _$SiteStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SiteStatusToJson(this);
}

extension SiteStatusExtension on SiteStatus {
  /// 檢查是否所有回收項目都為 DOWN 狀態
  /// 當 itemStatusList 為 null、空陣列，或所有元素的 status 都為 'DOWN' 時回傳 true
  bool get areAllItemsDown {
    // null 或空陣列 → 維護中
    if (itemStatusList == null || itemStatusList!.isEmpty) {
      return true;
    }

    // 檢查是否所有項目的 status 都為 'DOWN'
    return itemStatusList!.every((item) => item.status == 'DOWN');
  }
}
