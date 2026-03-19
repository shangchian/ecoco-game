import '/models/site_model.dart';
import '/models/site_status_model.dart';

/// Utility class for mapping bin codes to recyclable item types
class RecyclableItemMapper {
  /// Map binCode string to RecyclableItemType enum
  /// Returns null if binCode doesn't match any known type
  static RecyclableItemType? binCodeToItemType(String binCode) {
    switch (binCode.toUpperCase()) {
      case 'PET_BOTTLE':
        return RecyclableItemType.petBottle;
      case 'HDPE_BOTTLE':
        return RecyclableItemType.hdpeBottle;
      case 'PP_CUP':
        return RecyclableItemType.ppCup;
      case 'ALUMINUM_CAN':
        return RecyclableItemType.aluminumCan;
      case 'BATTERY':
        return RecyclableItemType.battery;
      default:
        return null;
    }
  }

  /// Extract available count for a specific recyclable item type from binStatusList
  /// Returns null if item not found or binStatusList is null/empty
  static int? getAvailableCount(
    List<BinStatus>? binStatusList,
    RecyclableItemType itemType,
  ) {
    if (binStatusList == null || binStatusList.isEmpty) {
      return null;
    }

    // Find bin status matching the item type
    for (final binStatus in binStatusList) {
      final mappedType = binCodeToItemType(binStatus.binCode);
      if (mappedType == itemType) {
        return binStatus.availableCount;
      }
    }

    return null; // Item type not found in binStatusList
  }

  /// Check if all bottle types (HDPE, PET, PP) have the same count
  /// Used to determine if bottles should be grouped
  /// Returns the unified count if all bottles present with same count, null otherwise
  static int? getUnifiedBottleCount(List<BinStatus>? binStatusList) {
    if (binStatusList == null || binStatusList.isEmpty) {
      return null;
    }

    final hdpeCount = getAvailableCount(binStatusList, RecyclableItemType.hdpeBottle);
    final petCount = getAvailableCount(binStatusList, RecyclableItemType.petBottle);
    final ppCount = getAvailableCount(binStatusList, RecyclableItemType.ppCup);

    // All three must be present
    if (hdpeCount == null || petCount == null || ppCount == null) {
      return null;
    }

    // All three must have same count
    if (hdpeCount == petCount && petCount == ppCount) {
      return hdpeCount;
    }

    return null; // Counts don't match
  }

  /// Map itemCode string (from ItemStatus) to RecyclableItemType enum
  /// Reuses the same logic as binCodeToItemType
  static RecyclableItemType? itemCodeToItemType(String itemCode) {
    return binCodeToItemType(itemCode);
  }

  /// Map RecyclableItemType enum to itemCode string
  /// Returns the string representation used in API (e.g., "PET_BOTTLE")
  static String itemTypeToItemCode(RecyclableItemType itemType) {
    switch (itemType) {
      case RecyclableItemType.petBottle:
        return 'PET_BOTTLE';
      case RecyclableItemType.hdpeBottle:
        return 'HDPE_BOTTLE';
      case RecyclableItemType.ppCup:
        return 'PP_CUP';
      case RecyclableItemType.aluminumCan:
        return 'ALUMINUM_CAN';
      case RecyclableItemType.battery:
        return 'BATTERY';
    }
  }

  /// Get all items linked to a specific bin
  /// Returns empty list if no items linked to this bin
  static List<ItemStatus> getItemsForBin(
    String binCode,
    List<ItemStatus>? itemStatusList,
  ) {
    if (itemStatusList == null || itemStatusList.isEmpty) {
      return [];
    }

    return itemStatusList
        .where((item) => item.linkedBinCode == binCode)
        .toList();
  }

  /// Check if itemCode is supported in site's recyclableItems list
  /// Verifies if the item type from itemCode exists in site's supported items
  static bool isItemTypeSupported(
    String itemCode,
    List<RecyclableItemType> recyclableItems,
  ) {
    final itemType = itemCodeToItemType(itemCode);
    if (itemType == null) return false;
    return recyclableItems.contains(itemType);
  }

  /// Returns the sort priority for a bin code
  /// Lower numbers = higher priority (displayed first)
  /// ALUMINUM_BIN: 0 (first), BATTERY_BIN: 1 (second), others: 2
  static int getBinSortPriority(String binCode) {
    switch (binCode.toUpperCase()) {
      case 'ALUMINUM_BIN':
        return 0; // First
      case 'BATTERY_BIN':
        return 1; // Second
      default:
        return 2; // All others
    }
  }
}
