import 'package:auto_route/auto_route.dart';
import '../../../ecoco_icons.dart';
import '/providers/area_district_provider.dart';
import '/providers/sorted_sites_provider.dart';
import '/providers/site_filter_provider.dart';
import '/providers/site_provider.dart';
import '/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '/pages/main/sites/widgets/site_list_card.dart';
import '/pages/main/sites/widgets/location_permission_banner.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/l10n/app_localizations.dart';
import '/constants/colors.dart';
import '/models/site_display_model.dart';
import '/models/site_model.dart';
import '/models/site_status_model.dart';
import '/utils/recyclable_item_mapper.dart';
import '/utils/snackbar_helper.dart';
import '/models/area_model.dart';
import '/utils/error_messages.dart';
import '/models/country_model.dart';
import '/models/district_model.dart';
import '/widgets/highlighted_picker_item.dart';
import '/router/app_router.dart';
import '/utils/router_analytics_extension.dart';

class SitesListView extends ConsumerStatefulWidget {
  final Function(bool) onLoadingChanged;

  const SitesListView({super.key, required this.onLoadingChanged});

  @override
  ConsumerState<SitesListView> createState() => _SitesListViewState();
}

class _SitesListViewState extends ConsumerState<SitesListView> {
  late final FocusNode _searchFocusNode;
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  bool _isBannerDismissed = false; // Track banner dismissal state
  bool _isFirstLoad = true; // Track first load of this view
  bool _showBackToTop = false;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sortedSitesProvider.notifier).resetSorting();
      ref.read(siteFilterProvider.notifier).reset();
    });
  }

  @override
  void deactivate() {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    super.deactivate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (!_searchFocusNode.hasFocus && _searchController.text.isNotEmpty) {
      FirebaseAnalytics.instance.logSearch(searchTerm: _searchController.text);
    }
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;

    // 向上滾動 (offset 變小) 且不在最頂端 → 顯示按鈕
    // 向下滾動 (offset 變大) → 隱藏按鈕
    final isScrollingUp = currentOffset < _lastScrollOffset;
    final isNotAtTop = currentOffset > 0;
    final showButton = isScrollingUp && isNotAtTop;

    if (showButton != _showBackToTop) {
      setState(() {
        _showBackToTop = showButton;
      });
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Actively request location permission on first load
    if (_isFirstLoad) {
      _isFirstLoad = false;
      // Use addPostFrameCallback to ensure this runs after build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          bool shouldRequest = true;
          try {
            // Only request prompt if this tab is active
            // This prevents prompt on startup if SitesListView is preloaded/restored in background
            final tabsRouter = AutoTabsRouter.of(context, watch: false);
            if (tabsRouter.activeIndex != 1) {
              shouldRequest = false;
            }
          } catch (_) {
            // If not in AutoTabsRouter (e.g. FavoriteSitesPage), always request
            shouldRequest = true;
          }

          if (shouldRequest) {
            ref.read(userLocationProvider.notifier).getUserLocation();
          }
          // Also load area/district data on first load
          ref.read(areaDistrictProvider.notifier).loadAreaDistrict();
        }
      });
    }
  }

  Future<void> _handleRefresh() async {
    // 隱藏目前可能還在顯示的 SnackBar
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();

    try {
      // Reset sorting so favorites can re-order on manual refresh
      ref.read(sortedSitesProvider.notifier).resetSorting();

      // Update location first (fire-and-forget, don't await)
      // This allows permission popup without blocking sites refresh
      // Reactive provider will auto-update distances when location changes
      ref.read(userLocationProvider.notifier).getUserLocation();

      // Refresh sites and statuses
      await ref
          .read(sitesProvider.notifier)
          .refresh()
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        SnackBarHelper.show(
          context,
          '已取得最新資料',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (mounted) {
        // Only show error snackbar in debug mode
        if (const bool.fromEnvironment('dart.vm.product') == false) {
          SnackBarHelper.show(
            context,
            'Debug: Refresh failed ($e)',
            duration: const Duration(seconds: 2),
          );
        }
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final sortedSitesAsync = ref.watch(sortedSitesProvider);
    final filter = ref.watch(siteFilterProvider);
    final area = ref.watch(areaDistrictProvider);

    // Listen to changes in the filter provider to sync the search text field
    ref.listen(siteFilterProvider, (previous, next) {
      if (next.searchQuery != _searchController.text) {
        _searchController.text = next.searchQuery;
        // Keep cursor at the end
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
      }
    });

    return sortedSitesAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (sortedSites) =>
          _buildSitesList(context, sortedSites, filter, area, appLocale),
      loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          )
      ),
      error: (error, stack) => Center(child: Text('Error: ${ErrorMessages.getDisplayMessage(error.toString())}')),
    );
  }

  Widget _buildSitesList(
    BuildContext context,
    List<Site> sortedSites,
    SiteFilter filter,
    Area area,
    AppLocalizations? appLocale,
  ) {
    String? selectedArea;
    String? selectedDistrict;

    final filteredSites = sortedSites.where((site) {
      bool matchesSearch = true;
      bool matchesLocation = true;
      bool matchesOpenStatus = true;
      bool matchesType = true;
      bool matchesRecyclable = true;
      bool isNotHidden = true;

      // 搜尋篩選
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        matchesSearch =
            site.name.toLowerCase().contains(query) ||
            site.address.toLowerCase().contains(query);
      }

      // 地區篩選
      if (filter.areaId != null) {
        matchesLocation = int.tryParse(site.areaId) == filter.areaId;
        if (filter.districtId != null) {
          matchesLocation =
              matchesLocation &&
              int.tryParse(site.districtId) == filter.districtId;
        }
      }

      // 營業中篩選 (可投 - can accept items)
      if (filter.showOpenOnly) {
        matchesOpenStatus = site.canAcceptItems;
      }

      // 類型篩選
      if (filter.hasTypeFilter) {
        matchesType = filter.selectedTypes.contains(site.type);
      }

      // 可回收物篩選
      if (filter.hasRecyclableItemFilter) {
        matchesRecyclable = filter.selectedRecyclableItems.any((item) {
          final supportsItem = site.recyclableItems.contains(item);
          if (!supportsItem) return false;

          // If showing Open Only, strictly check if this specific item is available
          if (filter.showOpenOnly) {
            return _checkItemAvailability(site, item);
          }
          return true;
        });
      }

      // 隱藏狀態篩選 - Filter out HIDDEN sites
      if (site.statusData?.displayStatus == 'HIDDEN') {
        isNotHidden = false;
      }

      return matchesSearch &&
          matchesLocation &&
          matchesOpenStatus &&
          matchesType &&
          matchesRecyclable &&
          isNotHidden;
    }).toList();

    // 獲取選中的地區名稱
    if (filter.areaId != null) {
      final country = area.countries
          .where((country) => country.areaId == filter.areaId)
          .firstOrNull;
      selectedArea = country?.name;

      if (filter.districtId != null && country != null) {
        final district = country.districts
            .where((district) => district.districtId == filter.districtId)
            .firstOrNull;
        selectedDistrict = district?.name;
      } else {
        selectedDistrict = null;
      }
    } else {
      selectedArea = null;
      selectedDistrict = null;
    }

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      child: Column(
        children: [
          // Fixed header section with yellow background
          Container(
            decoration: const BoxDecoration(
              color: AppColors.secondaryHighlightColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // 搜尋框
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 11),
                  child: MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: SizedBox(
                      height: 30, // 同步篩選按鈕的高度
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: const Color(0xFF808080),
                        cursorWidth: 1.4, // 游標粗細度
                        cursorRadius: const Radius.circular(2.0), // 游標圓角
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          ref
                              .read(siteFilterProvider.notifier)
                              .setSearchQuery(value);
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            FirebaseAnalytics.instance.logSearch(
                              searchTerm: value,
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: '搜尋站點名稱或地址',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF808080),
                            height: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 30, // 與外層的高度一致
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(top: 1.0), // 微調 icon 垂直位置
                            child: const Icon(
                              Icons.search,
                              color: Color(0xFF6B7280),
                              size: 20,
                            ),
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 30, // 與外層的高度一致
                          ),
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _searchController,
                            builder: (context, value, child) {
                              if (value.text.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Color(0xFF6B7280),
                                  size: 16,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(siteFilterProvider.notifier)
                                      .setSearchQuery('');
                                },
                              );
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                            bottom: 14,
                            left: 16,
                            right: 16,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16, height: 1.2),
                      ),
                    ),
                  ),
                ),

                // 三個篩選按鈕
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      // 選擇縣市按鈕
                      Expanded(
                        child: _buildAreaFilterButton(
                          context,
                          ref,
                          area,
                          selectedArea,
                          selectedDistrict,
                          appLocale,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 回收類別按鈕
                      Expanded(
                        child: _buildTypeFilterButton(context, ref, filter),
                      ),
                      const SizedBox(width: 8),

                      // 可投站點按鈕
                      Expanded(
                        child: _buildOpenStatusButton(
                          context,
                          ref,
                          filter.showOpenOnly,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Location permission banner (conditional)
          if (!ref.watch(userLocationProvider).shouldHideBanner &&
              !_isBannerDismissed)
            LocationPermissionBanner(
              onSettingsTap: () async {
                await Geolocator.openAppSettings();
              },
              onClose: () {
                setState(() {
                  _isBannerDismissed = true;
                });
              },
            ),

          // 站點列表 with rounded top corners
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.greyBackground,
                  ),
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: AppColors.primaryHighlightColor,
                    backgroundColor: Colors.white,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 16 + 80 + MediaQuery.paddingOf(context).bottom,
                      ),
                      itemCount: filteredSites.length,
                      itemBuilder: (context, index) {
                        final site = filteredSites[index];
                        final locationState = ref.watch(userLocationProvider);
                        final distanceText =
                            locationState.hasPermission && site.distance != null
                            ? (site.distance! > 999
                                  ? '無限大 km'
                                  : '${site.distance!.toStringAsFixed(2)} km')
                            : null;

                        // Convert site status to SiteCardStatus enum
                        // Use statusData for accurate status (aligns with filter logic)
                        SiteCardStatus cardStatus;
                        if (site.statusData != null) {
                          // PRIORITY 1: 檢查是否所有回收項目都為 DOWN（最高優先級）
                          if (site.statusData!.areAllItemsDown) {
                            cardStatus = SiteCardStatus.maintenance; // "維護中"
                          }
                          // PRIORITY 2: 檢查是否營運中且有容量
                          else {
                            final isOperational =
                                site.statusData!.displayStatus == 'NORMAL' &&
                                !(site.statusData!.isOffHours ?? false);

                            if (isOperational) {
                              // Site is operational (營業中)
                              // Check if has bin data to verify capacity
                              if (site.statusData!.binStatusList != null &&
                                  site.statusData!.binStatusList!.isNotEmpty) {
                                // Has bin data - check for available capacity
                                if (site.statusData!.binStatusList!.any(
                                  (bin) => bin.availableCount > 0,
                                )) {
                                  cardStatus = SiteCardStatus.available; // "可投"
                                } else {
                                  cardStatus = SiteCardStatus
                                      .closed; // "休息中" (no capacity)
                                }
                              } else {
                                // No bin data but site is operational - assume can accept (fallback)
                                cardStatus = SiteCardStatus.available; // "可投"
                              }
                            } else {
                              cardStatus = SiteCardStatus.closed; // "休息中"
                            }
                          }
                        } else {
                          // Fallback when no statusData available - use legacy status field
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

                        // Create recyclable item groups with actual API data
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
                          siteCode: site.code, // Pass site.code here
                          onTap: () {
                            _searchFocusNode.unfocus();
                          },
                          onFavoriteToggle: () async {
                            _searchFocusNode.unfocus();
                            // Toggle favorite - Stream automatically updates UI
                            final siteNotifier = ref.read(
                              sitesProvider.notifier,
                            );
                            try {
                              await siteNotifier.toggleFavorite(
                                site.code,
                                !site.favorite,
                              );
                            } catch (e) {
                              // Show error snackbar or dialog
                              if (context.mounted) {
                                final errorMessage = e.toString();
                                // Check if this is the favorite limit error
                                if (errorMessage.contains('已達收藏上限')) {
                                  SnackBarHelper.showWithWidget(
                                    context,
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: '已達收藏上限，',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '前往管理',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      context.router.pushThrottledWithTracking(
                                        const FavoriteSitesRoute(),
                                      );
                                    },
                                  );
                                } else {
                                  // For other errors, still show dialog
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => SimpleErrorAlert(
                                      message: errorMessage,
                                      buttonText: appLocale?.okay ?? '確定',
                                      onPressed: () {},
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                // 回到頂部按鈕
                if (_showBackToTop)
                  Positioned(
                    right: 8,
                    bottom: 122,
                    child: GestureDetector(
                      onTap: _scrollToTop,
                      child: Image.asset(
                        'assets/images/back_to_top.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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
  ///
  /// NEW LOGIC:
  /// - Each bin becomes one column (not each item type)
  /// - Icons shown per bin determined by itemStatusList.linkedBinCode
  /// - Multiple items can share one bin and availableCount
  /// - Each item icon gets individual color based on itemStatus.status
  List<RecyclableItemGroup> _buildRecyclableItemGroups(
    SiteType siteType,
    List<RecyclableItemType> recyclableItems,
    List<BinStatus>? binStatusList,
    List<ItemStatus>? itemStatusList,
  ) {
    final groups = <RecyclableItemGroup>[];

    // Fallback if no bin data
    if (binStatusList == null || binStatusList.isEmpty) {
      debugPrint('⚠️ Using fallback: binStatusList is null or empty');
      return _buildFallbackGroups(siteType, recyclableItems, itemStatusList);
    }

    debugPrint('📦 Building groups from ${binStatusList.length} bins');
    if (itemStatusList != null) {
      debugPrint('📋 itemStatusList has ${itemStatusList.length} items');
    } else {
      debugPrint('⚠️ itemStatusList is null');
    }

    // Sort bins: ALUMINUM_CAN first, BATTERY second, others after
    final sortedBinStatusList = List<BinStatus>.from(binStatusList)
      ..sort(
        (a, b) => RecyclableItemMapper.getBinSortPriority(
          a.binCode,
        ).compareTo(RecyclableItemMapper.getBinSortPriority(b.binCode)),
      );

    // Process each bin
    for (final binStatus in sortedBinStatusList) {
      final linkedItems = RecyclableItemMapper.getItemsForBin(
        binStatus.binCode,
        itemStatusList,
      );

      debugPrint(
        '  Bin ${binStatus.binCode}: ${linkedItems.length} linked items, count=${binStatus.availableCount}',
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

        final itemType = RecyclableItemMapper.itemCodeToItemType(
          itemStatus.itemCode,
        );
        if (itemType != null) {
          types.add(itemType);
          statuses.add(itemStatus.status);
          debugPrint('    - ${itemStatus.itemCode} (${itemStatus.status})');
        }
      }

      if (types.isEmpty) continue;

      debugPrint('  ✅ Created group with ${types.length} types');
      groups.add(
        RecyclableItemGroup.binGroup(
          binCode: binStatus.binCode,
          types: types,
          statuses: statuses,
          count: binStatus.availableCount,
        ),
      );
    }

    debugPrint('✅ Total groups created: ${groups.length}');
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
        String status = 'UP'; // Default to UP if no status data
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

        groups.add(
          RecyclableItemGroup.single(
            type: itemType,
            status: status,
            count: null,
          ),
        );
      }
    }

    return groups;
  }

  Widget _buildAreaFilterButton(
    BuildContext context,
    WidgetRef ref,
    dynamic area,
    String? selectedArea,
    String? selectedDistrict,
    AppLocalizations? appLocale,
  ) {
    final displayText = selectedArea != null
        ? (selectedDistrict != null
              ? '$selectedArea$selectedDistrict'
              : selectedArea)
        : '選擇縣市';

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        _showAreaPicker(context, ref, area);
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 6),
            Flexible(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _logFilterStationEvent() {
    final filter = ref.read(siteFilterProvider);
    final area = ref.read(areaDistrictProvider);

    // Resolve Area/District Name
    String city = '全部區域 全部區域';
    if (filter.areaId != null) {
      final country = area.countries.firstWhere(
        (c) => c.areaId == filter.areaId,
        orElse: () => CountryModel(areaId: -1, name: ''), // dummy
      );
      if (country.areaId != -1) {
        String districtName = '全部區域';
        if (filter.districtId != null) {
          final district = country.districts.firstWhere(
            (d) => d.districtId == filter.districtId,
            orElse: () =>
                DistrictModel(districtId: -1, areaId: -1, name: ''), // dummy
          );
          if (district.districtId != -1) {
            districtName = district.name;
          }
        }
        city = '${country.name} $districtName';
      }
    }

    // Resolve Category Name
    String category = '全部類別';
    if (filter.selectedRecyclableItems.isNotEmpty) {
      category = _getRecyclableItemDisplayName(
        filter.selectedRecyclableItems.first,
      );
    }

    FirebaseAnalytics.instance.logEvent(
      name: 'filter_station',
      parameters: {
        'city': city,
        'category': category,
        'is_open': filter.showOpenOnly.toString(),
      },
    );
  }

  void _showAreaPicker(BuildContext context, WidgetRef ref, dynamic area) {
    int selectedCountryIndex = 0;
    int selectedDistrictIndex = 0;

    // 找到當前選擇的縣市和區域索引
    final currentFilter = ref.read(siteFilterProvider);
    if (currentFilter.areaId != null) {
      final countryIndex = area.countries.indexWhere(
        (country) => country.areaId == currentFilter.areaId,
      );
      if (countryIndex != -1) {
        selectedCountryIndex = countryIndex + 1;

        if (currentFilter.districtId != null) {
          final country = area.countries[countryIndex];
          final districtIndex = country.districts.indexWhere(
            (district) => district.districtId == currentFilter.districtId,
          );
          if (districtIndex != -1) {
            selectedDistrictIndex = districtIndex + 1;
          }
        }
      }
    }

    final FixedExtentScrollController countryController =
        FixedExtentScrollController(initialItem: selectedCountryIndex);
    final FixedExtentScrollController districtController =
        FixedExtentScrollController(initialItem: selectedDistrictIndex);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Track current picker indices for highlighting
              int currentCountryPickerIndex = selectedCountryIndex;
              int currentDistrictPickerIndex = selectedDistrictIndex;

              final currentCountry = selectedCountryIndex > 0
                  ? area.countries[selectedCountryIndex - 1]
                  : null;

              return Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // 頂部操作欄
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              '取消',
                              style: TextStyle(
                                color: AppColors.secondaryValueColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Text(
                            '選擇縣市',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _searchFocusNode.unfocus();
                              if (selectedCountryIndex == 0) {
                                ref
                                    .read(siteFilterProvider.notifier)
                                    .setAreaId(null);
                                ref
                                    .read(siteFilterProvider.notifier)
                                    .setDistrictId(null);
                              } else {
                                final country =
                                    area.countries[selectedCountryIndex - 1];
                                if (selectedDistrictIndex == 0) {
                                  ref
                                      .read(siteFilterProvider.notifier)
                                      .setAreaId(country.areaId);
                                  ref
                                      .read(siteFilterProvider.notifier)
                                      .setDistrictId(null);
                                } else {
                                  final district = country
                                      .districts[selectedDistrictIndex - 1];
                                  ref
                                      .read(siteFilterProvider.notifier)
                                      .setAreaId(district.areaId);
                                  ref
                                      .read(siteFilterProvider.notifier)
                                      .setDistrictId(district.districtId);
                                }
                              }
                              _logFilterStationEvent();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '確定',
                              style: TextStyle(
                                color: AppColors.primaryHighlightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 雙滾輪選擇器
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: countryController,
                              itemExtent: 40,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  selectedCountryIndex = index;
                                  currentCountryPickerIndex = index;
                                  selectedDistrictIndex = 0;
                                  currentDistrictPickerIndex = 0;
                                  districtController.jumpToItem(0);
                                });
                              },
                              children: [
                                HighlightedPickerItem(
                                  text: '全部區域',
                                  itemIndex: 0,
                                  selectedIndex: currentCountryPickerIndex,
                                ),
                                ...area.countries.asMap().entries.map((entry) {
                                  return HighlightedPickerItem(
                                    text: entry.value.name,
                                    itemIndex: entry.key + 1,
                                    selectedIndex: currentCountryPickerIndex,
                                  );
                                }),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: districtController,
                              itemExtent: 40,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  selectedDistrictIndex = index;
                                  currentDistrictPickerIndex = index;
                                });
                              },
                              children: currentCountry != null
                                  ? [
                                      HighlightedPickerItem(
                                        text: '${currentCountry.name} - 全部區域',
                                        itemIndex: 0,
                                        selectedIndex:
                                            currentDistrictPickerIndex,
                                      ),
                                      ...currentCountry.districts
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                            return HighlightedPickerItem(
                                              text: entry.value.name,
                                              itemIndex: entry.key + 1,
                                              selectedIndex:
                                                  currentDistrictPickerIndex,
                                            );
                                          }),
                                    ]
                                  : [
                                      HighlightedPickerItem(
                                        text: '請先選擇縣市',
                                        itemIndex: 0,
                                        selectedIndex:
                                            currentDistrictPickerIndex,
                                      ),
                                    ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showRecyclableItemFilterDialog() {
    final currentFilter = ref.read(siteFilterProvider);

    // Find current selection index (0 = "全部類別", 1+ = specific items)
    int selectedIndex = 0;
    if (currentFilter.selectedRecyclableItems.isNotEmpty) {
      final allItems = [
        RecyclableItemType.petBottle,
        RecyclableItemType.ppCup,
        RecyclableItemType.hdpeBottle,
        RecyclableItemType.aluminumCan,
        RecyclableItemType.battery,
      ];
      selectedIndex =
          allItems.indexOf(currentFilter.selectedRecyclableItems.first) + 1;
    }

    int tempSelectedIndex = selectedIndex;

    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: selectedIndex);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Track current picker index for highlighting
              int currentItemPickerIndex = tempSelectedIndex;

              return Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // 頂部操作欄
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              '取消',
                              style: TextStyle(
                                color: AppColors.secondaryValueColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Text(
                            '選擇回收類別',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (tempSelectedIndex == 0) {
                                // Clear filter
                                ref
                                    .read(siteFilterProvider.notifier)
                                    .setSelectedRecyclableItems([]);
                              } else {
                                // Set single item
                                final allItems = [
                                  RecyclableItemType.petBottle,
                                  RecyclableItemType.ppCup,
                                  RecyclableItemType.hdpeBottle,
                                  RecyclableItemType.aluminumCan,
                                  RecyclableItemType.battery,
                                ];
                                final selectedItemType =
                                    allItems[tempSelectedIndex - 1];
                                ref
                                    .read(siteFilterProvider.notifier)
                                    .setSelectedRecyclableItems([
                                      selectedItemType,
                                    ]);
                              }
                              _logFilterStationEvent();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '確定',
                              style: TextStyle(
                                color: AppColors.primaryHighlightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // iOS 滾輪選擇器
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: scrollController,
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            tempSelectedIndex = index;
                            currentItemPickerIndex = index;
                          });
                        },
                        children: [
                          HighlightedPickerItem(
                            text: '全部類別',
                            itemIndex: 0,
                            selectedIndex: currentItemPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: _getRecyclableItemDisplayName(
                              RecyclableItemType.petBottle,
                            ),
                            itemIndex: 1,
                            selectedIndex: currentItemPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: _getRecyclableItemDisplayName(
                              RecyclableItemType.ppCup,
                            ),
                            itemIndex: 2,
                            selectedIndex: currentItemPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: _getRecyclableItemDisplayName(
                              RecyclableItemType.hdpeBottle,
                            ),
                            itemIndex: 3,
                            selectedIndex: currentItemPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: _getRecyclableItemDisplayName(
                              RecyclableItemType.aluminumCan,
                            ),
                            itemIndex: 4,
                            selectedIndex: currentItemPickerIndex,
                          ),
                          HighlightedPickerItem(
                            text: _getRecyclableItemDisplayName(
                              RecyclableItemType.battery,
                            ),
                            itemIndex: 5,
                            selectedIndex: currentItemPickerIndex,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTypeFilterButton(
    BuildContext context,
    WidgetRef ref,
    SiteFilter filter,
  ) {
    final selectedItems = filter.selectedRecyclableItems;
    final displayText = selectedItems.isEmpty
        ? '回收類別'
        : _getRecyclableItemDisplayName(selectedItems.first);

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        _showRecyclableItemFilterDialog();
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 6),
            Flexible(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenStatusButton(
    BuildContext context,
    WidgetRef ref,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        ref.read(siteFilterProvider.notifier).setOpenOnly(!isActive);
        _logFilterStationEvent();
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.buttomBackground : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '可投站點',
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive ? Colors.white : const Color(0xFF333333),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.6),
                    child: const Icon(
                      ECOCOIcons.checked,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRecyclableItemDisplayName(RecyclableItemType type) {
    switch (type) {
      case RecyclableItemType.petBottle:
        return '寶特瓶';
      case RecyclableItemType.aluminumCan:
        return '鋁罐';
      case RecyclableItemType.ppCup:
        return 'PP塑膠杯';
      case RecyclableItemType.hdpeBottle:
        return '牛奶瓶';
      case RecyclableItemType.battery:
        return '乾電池';
    }
  }

  /// Check if a specific item type is currently available at the site
  bool _checkItemAvailability(Site site, RecyclableItemType item) {
    // 1. If site status data is missing, we can't determine availability
    // Fallback to canAcceptItems logic (legacy up check)
    if (site.statusData == null) {
      return site.isOpen; 
    }

    final statusData = site.statusData!;

    // 2. Check general site status
    final isOperational = statusData.displayStatus == 'NORMAL' &&
        !(statusData.isOffHours ?? false);
    if (!isOperational) return false;
    
    // 3. Check maintenance (all items down)
    if (statusData.areAllItemsDown == true) return false;

    // 4. Find item status
    final itemCode = RecyclableItemMapper.itemTypeToItemCode(item);
    final itemStatusList = statusData.itemStatusList;
    
    if (itemStatusList == null || itemStatusList.isEmpty) return false;

    // Find the status for this item
    ItemStatus? itemStatus;
    try {
      itemStatus = itemStatusList.firstWhere((s) => s.itemCode == itemCode);
    } catch (_) {
      return false; // Item not found in status list
    }

    // Must be UP
    if (itemStatus.status != 'UP') return false;

    // 5. Check bin capacity if grouped bin (cardType not SEPARATE_BIN)
    final isSeparateBin = statusData.cardType == 'SEPARATE_BIN' || 
                          site.type == SiteType.separateBin;
                          
    if (!isSeparateBin) {
      // Must have capacity
      final binCode = itemStatus.linkedBinCode;
      if (binCode == null) return false; // Configuration error?

      final binStatusList = statusData.binStatusList;
      if (binStatusList == null) return false;

      try {
        final bin = binStatusList.firstWhere((b) => b.binCode == binCode);
        return bin.availableCount > 0;
      } catch (_) {
        return false; // Bin not found
      }
    }

    // For separate bins (H30), just UP status is enough
    return true;
  }
}
