// Display model for site card UI states
// This model is separate from the API Site model to handle UI-specific logic

import '/models/site_model.dart';

enum SiteCardStatus {
  available, // 可投 - Site is open and accepting items
  closed, // 休息中 - Site is temporarily closed
  maintenance, // 維護中 - Site is under maintenance
}

class RecyclableItemData {
  final RecyclableItemType type;
  final int count;
  final bool isSupported;

  const RecyclableItemData({
    required this.type,
    required this.count,
    this.isSupported = true,
  });

  /// Returns true if the item should be displayed as active (green)
  bool get isActive => isSupported && count > 0;

  /// Create mock data for testing
  static List<RecyclableItemData> createMockItems({
    List<RecyclableItemType>? types,
    int defaultCount = 999,
  }) {
    final itemTypes = types ??
        [
          RecyclableItemType.petBottle,
          RecyclableItemType.aluminumCan,
          RecyclableItemType.ppCup,
          RecyclableItemType.hdpeBottle,
          RecyclableItemType.battery,
        ];

    return itemTypes
        .map((type) => RecyclableItemData(
              type: type,
              count: defaultCount,
              isSupported: true,
            ))
        .toList();
  }

  /// Get display name for item type (Traditional Chinese)
  String get displayName {
    switch (type) {
      case RecyclableItemType.petBottle:
        return 'PET 寶特瓶';
      case RecyclableItemType.aluminumCan:
        return '鐵鋁罐';
      case RecyclableItemType.ppCup:
        return 'PP 塑膠杯';
      case RecyclableItemType.hdpeBottle:
        return 'HDPE 塑膠瓶';
      case RecyclableItemType.battery:
        return '電池';
    }
  }
}

/// Represents a display group that can contain either:
/// - A single recyclable item
/// - Multiple items linked to the same bin (via linkedBinCode)
class RecyclableItemGroup {
  final String? binCode; // Bin identifier from BinStatus
  final List<RecyclableItemType> types;
  final List<String> itemStatuses; // Individual status ("UP"/"DOWN") per item
  final int? count;
  final bool isGrouped;

  const RecyclableItemGroup({
    this.binCode,
    required this.types,
    required this.itemStatuses,
    this.count,
    this.isGrouped = false,
  });

  /// Create a single-item group
  factory RecyclableItemGroup.single({
    required RecyclableItemType type,
    String? status,
    int? count,
  }) {
    return RecyclableItemGroup(
      types: [type],
      itemStatuses: [status ?? 'UP'],
      count: count,
      isGrouped: false,
    );
  }

  /// Create a grouped bottle group (HDPE, PET, PP)
  /// @deprecated Use [RecyclableItemGroup.binGroup] for bin-based grouping
  @Deprecated('Use RecyclableItemGroup.binGroup for bin-based grouping')
  factory RecyclableItemGroup.bottleGroup({
    required int count,
  }) {
    return RecyclableItemGroup(
      types: [
        RecyclableItemType.hdpeBottle,
        RecyclableItemType.petBottle,
        RecyclableItemType.ppCup,
      ],
      itemStatuses: ['UP', 'UP', 'UP'],
      count: count,
      isGrouped: true,
    );
  }

  /// Create a bin-based group with multiple items
  factory RecyclableItemGroup.binGroup({
    required String binCode,
    required List<RecyclableItemType> types,
    required List<String> statuses,
    required int count,
  }) {
    assert(types.length == statuses.length, 'Types and statuses must have same length');
    return RecyclableItemGroup(
      binCode: binCode,
      types: types,
      itemStatuses: statuses,
      count: count,
      isGrouped: types.length > 1,
    );
  }

  /// Returns true if this group has a count to display
  bool get hasCount => count != null;

  /// Returns true if count > 0 (for green vs gray icon)
  bool get isActive => count != null && count! > 0;

  /// Get status for specific item type
  String? getItemStatus(RecyclableItemType type) {
    final index = types.indexOf(type);
    return index >= 0 && index < itemStatuses.length ? itemStatuses[index] : null;
  }

  /// Check if specific item is active (UP status)
  bool isItemActive(RecyclableItemType type) {
    final status = getItemStatus(type);
    return status == 'UP';
  }
}

extension SiteCardStatusExtension on SiteCardStatus {
  /// Get badge text for status
  String get badgeText {
    switch (this) {
      case SiteCardStatus.available:
        return '可投';
      case SiteCardStatus.closed:
        return '休息中';
      case SiteCardStatus.maintenance:
        return '維護中';
    }
  }

  /// Returns true if items should be displayed as active (colored)
  bool get itemsActive => this == SiteCardStatus.available;
}
