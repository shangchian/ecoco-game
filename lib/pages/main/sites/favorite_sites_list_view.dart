import 'dart:developer' as dev;
import '/providers/favorite_sites_provider.dart';
import '/providers/site_provider.dart';
import '/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/pages/main/sites/widgets/site_list_card.dart';
import '/pages/main/sites/widgets/favorite_empty_state.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/pages/common/loading_overlay.dart';
import '/constants/colors.dart';
import '/models/site_model.dart';
import '/models/site_display_model.dart';
import '/models/site_status_model.dart';
import '/utils/recyclable_item_mapper.dart';
import '/utils/snackbar_helper.dart';

class FavoriteSitesListView extends ConsumerStatefulWidget {
  final Function(bool) onLoadingChanged;

  const FavoriteSitesListView({
    super.key,
    required this.onLoadingChanged,
  });

  @override
  ConsumerState<FavoriteSitesListView> createState() =>
      _FavoriteSitesListViewState();
}

class _FavoriteSitesListViewState extends ConsumerState<FavoriteSitesListView> {
  late final FocusNode _searchFocusNode;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    try {
      // 不顯示 loading 狀態,RefreshIndicator 有自己的載入指示器
      await ref.read(favoriteSitesProvider.notifier).refresh();
    } catch (e) {
      if (mounted) {
        SnackBarHelper.show(context, '更新失敗，請稍後再試');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSitesAsync = ref.watch(favoriteSitesProvider);

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      child: Column(
        children: [
          // Sites list or empty state with AsyncValue handling
          Expanded(
            child: favoriteSitesAsync.when(
              // 載入狀態 - 顯示載入動畫
              loading: () => const LoadingOverlay(),

              // 錯誤狀態 - 顯示空狀態並記錄錯誤
              error: (error, stackTrace) {
                dev.log('Error loading favorites: $error');
                return const FavoriteEmptyState();
              },

              // 資料狀態 - 顯示列表或空狀態
              data: (favoriteSites) {
                // 如果沒有收藏站點,顯示空狀態
                if (favoriteSites.isEmpty) {
                  return const FavoriteEmptyState();
                }

                // Filter by search query
                final filteredSites = favoriteSites.toList();

                // 顯示站點列表
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.greyBackground,
                  ),
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: AppColors.primaryHighlightColor,
                    child: filteredSites.isEmpty
                        ? _buildNoResultsView()
                        : ListView.builder(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom:
                                    16 + 80 + MediaQuery.paddingOf(context).bottom,
                              ),
                              itemCount: filteredSites.length + 1,
                              itemBuilder: (context, index) {
                                // Render bottom text as last item
                                if (index == filteredSites.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Center(
                                      child: Text(
                                        '最多可收藏 5 個站點',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryValueColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final site = filteredSites[index];
                                final locationState =
                                    ref.watch(userLocationProvider);
                                final distanceText = locationState.hasPermission &&
                                        site.distance != null
                                    ? (site.distance! > 999
                                        ? '無限大 km'
                                        : '${site.distance!.toStringAsFixed(2)} km')
                                    : null;

                                // Convert site status to SiteCardStatus enum
                                SiteCardStatus cardStatus;
                                if (site.statusData != null) {
                                  // PRIORITY 1: 檢查是否所有回收項目都為 DOWN（最高優先級）
                                  if (site.statusData!.areAllItemsDown) {
                                    cardStatus = SiteCardStatus.maintenance;  // "維護中"
                                  }
                                  // PRIORITY 2: 檢查是否營運中且有容量
                                  else {
                                    final isOperational =
                                        site.statusData!.displayStatus == 'NORMAL' &&
                                            !(site.statusData!.isOffHours ?? false);

                                    if (isOperational) {
                                      if (site.statusData!.binStatusList != null &&
                                          site.statusData!.binStatusList!.isNotEmpty) {
                                        if (site.statusData!.binStatusList!
                                            .any((bin) => bin.availableCount > 0)) {
                                          cardStatus = SiteCardStatus.available;
                                        } else {
                                          cardStatus = SiteCardStatus.closed;
                                        }
                                      } else {
                                        cardStatus = SiteCardStatus.available;
                                      }
                                    } else {
                                      cardStatus = SiteCardStatus.closed;
                                    }
                                  }
                                } else {
                                  if (site.status?.toLowerCase() == 'up') {
                                    cardStatus = SiteCardStatus.available;
                                  } else if (site.status?.toLowerCase() ==
                                      'maintenance') {
                                    cardStatus = SiteCardStatus.maintenance;
                                  } else {
                                    cardStatus = SiteCardStatus.closed;
                                  }
                                }

                                // Get site type from statusData.cardType (more reliable than site.type)
                                final siteTypeFromStatus = _getSiteType(site);

                                // Create recyclable item groups
                                final recyclableGroups = _buildRecyclableItemGroups(
                                  siteTypeFromStatus,
                                  site.recyclableItems,
                                  site.statusData?.binStatusList,
                                  site.statusData?.itemStatusList,
                                );

                                return SiteListCard(
                                  title: site.name,
                                  address: site.address,
                                  serviceHours: site.serviceHours,
                                  distance: distanceText,
                                  isFavorite: site.favorite,
                                  status: cardStatus,
                                  displayStatus: site.statusData?.displayStatus,
                                  noteText: site.note,
                                  siteType: siteTypeFromStatus,
                                  recyclableGroups: recyclableGroups,
                                  latitude: site.latitude,
                                  longitude: site.longitude,
                                  onTap: () {
                                    _searchFocusNode.unfocus();
                                  },
                                  onFavoriteToggle: () async {
                                    _searchFocusNode.unfocus();
                                    // Don't show loading overlay - optimistic update provides instant feedback
                                    final siteNotifier =
                                        ref.read(sitesProvider.notifier);
                                    try {
                                      // Since we're in favorites, user is unfavoriting
                                      await siteNotifier.toggleFavorite(site.code, false);
                                    } catch (e) {
                                      // Exception thrown - already rolled back
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => SimpleErrorAlert(
                                            message: e.toString(),
                                            buttonText: '確定',
                                            onPressed: () {},
                                          ),
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 60),
        const Icon(
          Icons.search_off,
          size: 80,
          color: Color(0xFF9CA3AF),
        ),
        const SizedBox(height: 16),
        const Text(
          '找不到符合的站點',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  /// Parse cardType from SiteStatus to SiteType enum
  /// Falls back to site.type if cardType is not available
  SiteType _getSiteType(Site site) {
    final cardType = site.statusData?.cardType;
    if (cardType != null) {
      if (cardType == 'SEPARATE_BIN') {
        return SiteType.separateBin;
      } else if (cardType == 'GROUPED_BIN') {
        return SiteType.groupedBin;
      }
    }
    // Fallback to site.type (which defaults to groupedBin)
    return site.type;
  }

  /// Build recyclable item groups from bin-centric data
  List<RecyclableItemGroup> _buildRecyclableItemGroups(
    SiteType siteType,
    List<RecyclableItemType> recyclableItems,
    List<BinStatus>? binStatusList,
    List<ItemStatus>? itemStatusList,
  ) {
    final groups = <RecyclableItemGroup>[];

    // Fallback if no bin data
    if (binStatusList == null || binStatusList.isEmpty) {
      return _buildFallbackGroups(siteType, recyclableItems, itemStatusList);
    }

    // Sort bins: ALUMINUM_CAN first, BATTERY second, others after
    final sortedBinStatusList = List<BinStatus>.from(binStatusList)
      ..sort((a, b) => RecyclableItemMapper.getBinSortPriority(a.binCode)
          .compareTo(RecyclableItemMapper.getBinSortPriority(b.binCode)));

    // Process each bin
    for (final binStatus in sortedBinStatusList) {
      final linkedItems = RecyclableItemMapper.getItemsForBin(
        binStatus.binCode,
        itemStatusList,
      );

      if (linkedItems.isEmpty) continue;

      final types = <RecyclableItemType>[];
      final statuses = <String>[];

      for (final itemStatus in linkedItems) {
        if (!RecyclableItemMapper.isItemTypeSupported(
          itemStatus.itemCode,
          recyclableItems,
        )) {
          continue;
        }

        final itemType =
            RecyclableItemMapper.itemCodeToItemType(itemStatus.itemCode);
        if (itemType != null) {
          types.add(itemType);
          statuses.add(itemStatus.status);
        }
      }

      if (types.isEmpty) continue;

      groups.add(RecyclableItemGroup.binGroup(
        binCode: binStatus.binCode,
        types: types,
        statuses: statuses,
        count: binStatus.availableCount,
      ));
    }

    return groups;
  }

  /// Fallback for sites without status data
  List<RecyclableItemGroup> _buildFallbackGroups(
    SiteType siteType,
    List<RecyclableItemType> recyclableItems,
    List<ItemStatus>? itemStatusList,
  ) {
    final groups = <RecyclableItemGroup>[];
    final displayOrder = [
      RecyclableItemType.aluminumCan,
      RecyclableItemType.battery,
      RecyclableItemType.hdpeBottle,
      RecyclableItemType.petBottle,
      RecyclableItemType.ppCup,
    ];

    for (final itemType in displayOrder) {
      if (recyclableItems.contains(itemType)) {
        // Find actual status from itemStatusList
        String status = 'UP';  // Default to UP if no status data
        if (itemStatusList != null && itemStatusList.isNotEmpty) {
          final itemCode = RecyclableItemMapper.itemTypeToItemCode(itemType);
          try {
            final itemStatus = itemStatusList.firstWhere(
              (item) => item.itemCode == itemCode,
            );
            status = itemStatus.status;
          } catch (_) {
            // Item not found in status list, keep default 'UP'
          }
        }

        groups.add(RecyclableItemGroup.single(
          type: itemType,
          status: status,
          count: null,
        ));
      }
    }

    return groups;
  }
}
