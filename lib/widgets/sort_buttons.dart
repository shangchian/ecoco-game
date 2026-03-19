import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/area_district_provider.dart';
import '/models/coupon_rule.dart';
import 'highlighted_picker_item.dart';

/// 排序類型列舉
enum SortType {
  /// 綜合排序
  comprehensive,

  /// 最新上架
  newest,

  /// 點數高到低
  pointsDescending,

  /// 點數低到高
  pointsAscending,
}

/// 點數區間列舉
enum PointsRange {
  /// 1-100 點
  range1To100('1~100點'),

  /// 101-200 點
  range101To200('101~200點'),

  /// 201-300 點
  range201To300('201~300點'),

  /// 301-400 點
  range301To400('301~400點'),

  /// 401-500 點
  range401To500('401~500點'),

  /// 大於 500 點
  rangeAbove500('> 500點');

  const PointsRange(this.label);
  final String label;
}

/// 商家類別列舉
enum MerchantCategory {
  /// 購物
  shopping('購物'),

  /// 餐飲
  dining('餐飲'),

  /// 生活
  lifestyle('生活'),

  /// 育樂
  entertainment('育樂'),

  /// 健康
  health('健康'),

  /// 公益
  publicWelfare('公益'),

  /// 換點
  pointExchange('換點');

  const MerchantCategory(this.label);
  final String label;

  /// Convert to CouponCategory
  CouponCategory? get toCouponCategory {
    switch (this) {
      case MerchantCategory.shopping:
        return CouponCategory.shopping;
      case MerchantCategory.dining:
        return CouponCategory.food;
      case MerchantCategory.lifestyle:
        return CouponCategory.lifestyle;
      case MerchantCategory.entertainment:
        return CouponCategory.recreation;
      case MerchantCategory.health:
        return CouponCategory.health;
      case MerchantCategory.publicWelfare:
        return CouponCategory.charity;
      case MerchantCategory.pointExchange:
        return CouponCategory.pointsExchange;
    }
  }
}

/// 篩選選項
class FilterOptions {
  /// 選中的縣市 ID
  final int? countyId;

  /// 選中的點數區間
  final PointsRange? pointsRange;

  /// 選中的商家類別
  final MerchantCategory? category;

  const FilterOptions({this.countyId, this.pointsRange, this.category});

  /// 是否有啟用的篩選條件
  bool get hasActiveFilters =>
      countyId != null || pointsRange != null || category != null;

  /// 複製並修改
  FilterOptions copyWith({
    int? countyId,
    PointsRange? pointsRange,
    MerchantCategory? category,
    bool clearCounty = false,
    bool clearPointsRange = false,
    bool clearCategory = false,
  }) {
    return FilterOptions(
      countyId: clearCounty ? null : (countyId ?? this.countyId),
      pointsRange: clearPointsRange ? null : (pointsRange ?? this.pointsRange),
      category: clearCategory ? null : (category ?? this.category),
    );
  }

  /// 清除所有篩選
  FilterOptions clear() {
    return const FilterOptions();
  }
}

/// 排序和篩選按鈕元件
/// 提供排序選項（左側）和篩選功能（右側）
class SortButtons extends ConsumerStatefulWidget {
  /// 當前選中的排序類型
  final SortType selectedSort;

  /// 排序改變時的回調函數
  final ValueChanged<SortType>? onSortChanged;

  /// 當前的篩選選項
  final FilterOptions? filterOptions;

  /// 篩選改變時的回調函數
  final ValueChanged<FilterOptions?>? onFilterChanged;

  const SortButtons({
    super.key,
    this.selectedSort = SortType.comprehensive,
    this.onSortChanged,
    this.filterOptions,
    this.onFilterChanged,
  });

  @override
  ConsumerState<SortButtons> createState() => _SortButtonsState();
}

class _SortButtonsState extends ConsumerState<SortButtons> {
  late SortType _selectedSort;
  FilterOptions _filterOptions = const FilterOptions();

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.selectedSort;
    _filterOptions = widget.filterOptions ?? const FilterOptions();
    // 確保載入縣市資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(areaDistrictProvider.notifier).loadAreaDistrict();
    });
  }

  @override
  void didUpdateWidget(SortButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSort != oldWidget.selectedSort) {
      _selectedSort = widget.selectedSort;
    }
    if (widget.filterOptions != oldWidget.filterOptions) {
      _filterOptions = widget.filterOptions ?? const FilterOptions();
    }
  }

  void _handleSortChange(SortType sort) {
    if (_selectedSort != sort) {
      setState(() {
        _selectedSort = sort;
      });
      widget.onSortChanged?.call(sort);
    }
  }

  void _handlePointsSortToggle() {
    // 如果當前不是點數排序，預設為降序
    if (_selectedSort != SortType.pointsDescending &&
        _selectedSort != SortType.pointsAscending) {
      _handleSortChange(SortType.pointsDescending);
    } else {
      // 在升序和降序之間切換
      final newSort = _selectedSort == SortType.pointsDescending
          ? SortType.pointsAscending
          : SortType.pointsDescending;
      _handleSortChange(newSort);
    }
  }

  void _handleFilterChange(FilterOptions? options) {
    setState(() {
      _filterOptions = options ?? const FilterOptions();
    });
    widget.onFilterChanged?.call(options);
  }

  void _handleClearFilters() {
    _handleFilterChange(const FilterOptions());
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        initialFilter: _filterOptions,
        counties: ref.read(areaDistrictProvider).countries,
      ),
    ).then((result) {
      if (result != null) {
        _handleFilterChange(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 判斷當前是否為點數排序狀態
    final isPointsSort =
        _selectedSort == SortType.pointsDescending ||
        _selectedSort == SortType.pointsAscending;

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左側：排序按鈕群組
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SortButton(
                  label: '綜合排序',
                  isSelected: _selectedSort == SortType.comprehensive,
                  onTap: () => _handleSortChange(SortType.comprehensive),
                ),
                const SizedBox(width: 8),
                _SortButton(
                  label: '點數',
                  isSelected: isPointsSort,
                  onTap: _handlePointsSortToggle,
                  icon: !isPointsSort
                      ? 'assets/images/sort_none.png'
                      : (_selectedSort == SortType.pointsAscending
                            ? 'assets/images/sort_up.png'
                            : 'assets/images/sort_down.png'),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _filterOptions.hasActiveFilters ?AppColors.buttomBackground : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _filterOptions.hasActiveFilters ?AppColors.buttomBackground : Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _SortButton(
              label: '篩選',
              isSelected: _filterOptions.hasActiveFilters,
              onTap: _showFilterBottomSheet,
              //icon: Icons.filter_alt,
            ),
          ),
          _ClearFilterButton(
            hasActiveFilters: _selectedSort != SortType.comprehensive || _filterOptions.hasActiveFilters,
            onTap: _handleClearFilters,
          ),
        ],
      ),
    );
  }
}

/// 單個排序/篩選按鈕元件
class _SortButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final dynamic icon; // 可以是 IconData 或 String (image path)

  const _SortButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangeBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              // 根據 icon 類型顯示不同的 widget
              if (icon is String)
                Image.asset(
                  icon,
                  height: 14,
                  width: 14,
                  fit: BoxFit.contain,
                  color: isSelected ? Colors.white : Colors.black54,
                )
              else if (icon is IconData)
                Transform.translate(
                  offset: const Offset(0, -0.5),
                  child: Icon(
                    icon,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 清除篩選按鈕（X 按鈕）
class _ClearFilterButton extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onTap;

  const _ClearFilterButton({
    required this.hasActiveFilters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? Colors.transparent
              : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: hasActiveFilters
                ? AppColors.indicatorColor
                : Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.close,
          size: 12,
          fontWeight: FontWeight.bold,
          color: hasActiveFilters ? AppColors.indicatorColor : AppColors.thirdValueColor,
        ),
      ),
    );
  }
}

/// 篩選底部彈窗
class _FilterBottomSheet extends StatefulWidget {
  final FilterOptions initialFilter;
  final List counties;

  const _FilterBottomSheet({
    required this.initialFilter,
    required this.counties,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late int? _selectedCountyId;
  late PointsRange? _selectedPointsRange;
  late MerchantCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCountyId = widget.initialFilter.countyId;
    _selectedPointsRange = widget.initialFilter.pointsRange;
    _selectedCategory = widget.initialFilter.category;
  }

  void _showCountyPicker() {
    // 建立選項列表：「全部」 + 所有縣市
    final List<String> pickerItems = [
      '全部',
      ...widget.counties.map((c) => c.name as String),
    ];

    // 找出當前選中項目的索引
    int initialIndex = 0;
    if (_selectedCountyId != null) {
      final countyIndex = widget.counties.indexWhere(
        (c) => c.areaId == _selectedCountyId,
      );
      if (countyIndex != -1) {
        initialIndex = countyIndex + 1; // +1 因為「全部」在第 0 位
      }
    }

    // 暫存選中的索引
    int tempSelectedIndex = initialIndex;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Track current picker index for highlighting
            int currentPickerIndex = tempSelectedIndex;

            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Container(
                height: 300,
                color: CupertinoColors.systemBackground.resolveFrom(context),
                child: Column(
                  children: [
                    // 標題列：取消和完成按鈕
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground.resolveFrom(
                          context,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.separator.resolveFrom(
                              context,
                            ),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: const Text(
                              '取消',
                              style: TextStyle(height: 1.4),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoButton(
                            child: const Text(
                              '完成',
                              style: TextStyle(height: 1.4),
                            ),
                            onPressed: () {
                              setState(() {
                                if (tempSelectedIndex == 0) {
                                  _selectedCountyId = null;
                                } else {
                                  final county =
                                      widget.counties[tempSelectedIndex - 1];
                                  _selectedCountyId = county.areaId as int?;
                                }
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    // 滾輪選擇器
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: initialIndex,
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          tempSelectedIndex = index;
                          setModalState(() {
                            currentPickerIndex = index;
                          });
                        },
                        children: pickerItems.asMap().entries.map((entry) {
                          return HighlightedPickerItem(
                            text: entry.value,
                            itemIndex: entry.key,
                            selectedIndex: currentPickerIndex,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getCountyDisplayName() {
    if (_selectedCountyId == null) return '選擇縣市';
    try {
      final county = widget.counties.firstWhere(
        (c) => c.areaId == _selectedCountyId,
      );
      return county.name as String;
    } catch (e) {
      return '選擇縣市';
    }
  }

  void _handleConfirm() {
    final result = FilterOptions(
      countyId: _selectedCountyId,
      pointsRange: _selectedPointsRange,
      category: _selectedCategory,
    );
    Navigator.of(context).pop(result);
  }

  void _handleClear() {
    setState(() {
      _selectedCountyId = null;
      _selectedPointsRange = null;
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 標題列
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _handleClear,
                      child: const Text(
                        '清除設定',
                        style: TextStyle(
                          color: Color(0xFF007AFF),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Text(
                      '篩選           ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              // 篩選內容
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 縣市篩選
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '區域限定',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: _showCountyPicker,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getCountyDisplayName(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedCountyId != null
                                          ? AppColors.primaryHighlightColor
                                          : AppColors.secondaryValueColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: _selectedCountyId != null
                                          ? AppColors.primaryHighlightColor
                                          : AppColors.secondaryValueColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 點數區間篩選
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '點數區間',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: PointsRange.values.map((range) {
                              final isSelected = _selectedPointsRange == range;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedPointsRange = isSelected
                                        ? null
                                        : range;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.orangeBackground
                                        : AppColors.greyBackground,
                                    border: Border.all(
                                      width: 1,
                                      color: isSelected
                                          ? AppColors.orangeBackground
                                          : AppColors.loginButtonGray,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    range.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 類別篩選
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '類別',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: MerchantCategory.values.map((category) {
                                final isSelected =
                                    _selectedCategory == category;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = isSelected
                                          ? null
                                          : category;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 21,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.orangeBackground
                                          : AppColors.greyBackground,
                                      border: Border.all(
                                        width: 1,
                                        color: isSelected
                                            ? AppColors.orangeBackground
                                            : AppColors.loginButtonGray,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      category.label,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 確認按鈕
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeBackground,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '確認',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
