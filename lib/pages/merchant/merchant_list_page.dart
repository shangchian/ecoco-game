import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../models/brand_model.dart';
import '../../providers/brand_provider.dart';
import '../../router/app_router.dart';
import '../../utils/error_messages.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class MerchantListPage extends ConsumerStatefulWidget {
  const MerchantListPage({super.key});

  @override
  ConsumerState<MerchantListPage> createState() => _MerchantListPageState();
}

class _MerchantListPageState extends ConsumerState<MerchantListPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<BrandCategory, GlobalKey> _categoryKeys = {};
  BrandCategory _selectedCategory = BrandCategory.lifestyleRetail;
  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;

  List<BrandCategory> _availableCategories = [];
  Map<BrandCategory, List<Brand>> _brandsByCategory = {};

  // All categories
  final List<BrandCategory> _allCategories = BrandCategory.values;

  @override
  void initState() {
    super.initState();
    // Initialize GlobalKeys for each category
    for (final category in _allCategories) {
      _categoryKeys[category] = GlobalKey();
    }

    // Add scroll listener to update selected category
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _removeOverlay();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Update available categories and brands
  void _updateBrandsData(List<Brand> allBrands) {
    final grouped = <BrandCategory, List<Brand>>{};

    for (final category in _allCategories) {
      final categoryBrands = allBrands
          .where((brand) => brand.category == category)
          .toList();
      if (categoryBrands.isNotEmpty) {
        grouped[category] = categoryBrands;
      }
    }

    _brandsByCategory = grouped;
    _availableCategories = _allCategories.where((cat) => grouped.containsKey(cat)).toList();

    // Ensure selected category is valid
    if (_availableCategories.isNotEmpty && !_availableCategories.contains(_selectedCategory)) {
      _selectedCategory = _availableCategories.first;
    }
  }

  // Calculate total pinned header height
  double get _pinnedHeaderHeight {
    final padding = MediaQuery.of(context).padding.top;
    return padding + kToolbarHeight + 46.0; // StatusBar + AppBar + PersistentHeader
  }

  // Calculate target offset for a category based on content height
  double _calculateTargetOffset(BrandCategory targetCategory) {
    if (_brandsByCategory.isEmpty) return 0;
    
    // Safety check for first/last
    if (targetCategory == _availableCategories.first) return 0;
    
    double offset = 0;

    // Constants from _CategorySection and build method
    const itemSpacing = 22.0;
    const sectionVerticalPadding = 24.0; // 12 margin-top + 12 padding-top
    const sectionBottomPadding = 24.0; // 12 margin-bottom + 12 padding-bottom
    const titleHeight = 19.0; // Approx height for 16px text
    const titleBottomMargin = 16.0;
    const itemHeight = 94.0; // 70 + 8 + 16
    
    // Fixed to 4 columns to match UI layout
    const itemsPerRow = 4;

    for (final category in _availableCategories) {
      if (category == targetCategory) break;

      offset += sectionVerticalPadding;
      offset += titleHeight + titleBottomMargin;

      final brands = _brandsByCategory[category] ?? [];
      if (brands.isNotEmpty) {
        final rows = (brands.length / itemsPerRow).ceil();
        final gridHeight = rows * itemHeight + (rows - 1) * itemSpacing;
        offset += gridHeight;
      }

      offset += sectionBottomPadding;
    }

    return offset;
  }

  // Scroll listener to update current category
  void _onScroll() {
    if (!_scrollController.hasClients || _availableCategories.isEmpty) return;

    final currentOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    // Dynamic threshold based on pinned header
    final threshold = _pinnedHeaderHeight;
    const tolerance = 10.0;

    BrandCategory? bestMatch;
    double bestDistance = double.infinity;
    bool foundAnyValidContext = false;

    // First try to find category by rendered position
    for (final category in _availableCategories) {
      final key = _categoryKeys[category];
      if (key?.currentContext != null) {
        foundAnyValidContext = true;
        final RenderBox? box = key!.currentContext!.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          // Position relative to the top of the viewport
          final sectionTop = position.dy;

          // We want the section that is closest to the bottom of the header
          if (sectionTop <= threshold + tolerance) {
            final distance = threshold - sectionTop;
            if (distance < bestDistance) {
              bestDistance = distance;
              bestMatch = category;
            }
          }
        }
      }
    }

    // Fallback logic if no clear match found above
    if (bestMatch == null) {
      if (currentOffset < 50) {
        bestMatch = _availableCategories.first;
      } else if (currentOffset > maxScroll - 50) {
        bestMatch = _availableCategories.last;
      } else if (foundAnyValidContext) {
        double minShift = double.infinity;
        for (final category in _availableCategories) {
             final key = _categoryKeys[category];
             if (key?.currentContext != null) {
                final RenderBox? box = key!.currentContext!.findRenderObject() as RenderBox?;
                if (box != null) {
                   final pos = box.localToGlobal(Offset.zero).dy;
                   // Logic: Find the first category that is "just below" the header
                   if (pos > threshold - tolerance && pos < minShift) {
                     minShift = pos;
                   }
                }
             }
        }
      }
    }
    
    // If still null, calculate based on offset
    if (bestMatch == null) {
       // Reverse calculation could be expensive, just stick to previous or approximate
       // But usually the rendered check covers the active area.
    }

    if (bestMatch != null && _selectedCategory != bestMatch && mounted) {
      setState(() {
        _selectedCategory = bestMatch!;
      });
    }
  }

  // Smooth scroll to category
  void _scrollToCategory(BrandCategory category) {
    if (!mounted) return;
    
    final key = _categoryKeys[category];
    double targetOffset;
    final headerHeight = _pinnedHeaderHeight;

    if (key?.currentContext != null) {
      // Context is valid, use precise calculation from current position
      final RenderBox box = key!.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      // currentOffset + (elementY - headerBottomY)
      // elementY is position.dy
      // headerBottomY is headerHeight
      targetOffset = _scrollController.offset + position.dy - headerHeight;
    } else {
      // Context is null, use calculated position
      targetOffset = _calculateTargetOffset(category);
    }
    
    // Clamp to valid range
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (targetOffset > maxScroll) {
       targetOffset = maxScroll;
    }
    if (targetOffset < 0) targetOffset = 0;

    _scrollController.jumpTo(targetOffset);

    if (mounted) {
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  // Create overlay entry for dropdown
  OverlayEntry _createOverlayEntry() {
    // Calculate AppBar bottom edge position: status bar + AppBar (56) + Category buttons (38)
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = statusBarHeight + kToolbarHeight;
    const double dropdownTop = 141.0;

    return OverlayEntry(
      builder: (context) => Positioned(
        top: appBarHeight,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Backdrop overlay
              GestureDetector(
                onTap: () {
                  if (mounted) {
                    _removeOverlay();
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height - dropdownTop,
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
              // Dropdown content
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Placeholder text
                    Container(
                      key: const ValueKey('placeholder'),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft, 
                        child: const Text(
                          '請選擇商家類型',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF808080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Category pills
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableCategories.map((category) {
                          final isSelected = category == _selectedCategory;
                          return GestureDetector(
                            onTap: () => _onCategorySelected(category),
                            child: Container(
                              width: 80,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryHighlightColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryHighlightColor
                                      : AppColors.greyBackground,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                category.displayName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected ? Colors.white : Color(0xFF808080),
                                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                                  height: 1.16, // 垂直置中輔助修正
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow close button (same style as original)
              Positioned(
                right: 0,
                top: 2,
                //bottom: 1,
                child: GestureDetector(
                  onTap: () {
                    if (mounted) {
                      _removeOverlay();
                    }
                  },
                  child: Container(
                    width: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.center,
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 1.0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: Color(0xFFFF5000),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Remove overlay
  void _removeOverlay() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry?.remove();
      } catch (e) {
        // Ignore errors if the overlay is already disposed or in defunct state
      }
      _overlayEntry = null;
    }

    if (mounted) {
      try {
        setState(() {
          _isDropdownOpen = false;
        });
      } catch (e) {
        // Ignore errors if widget is already disposed
      }
    }
  }

  // Toggle dropdown menu
  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      setState(() {
        _isDropdownOpen = true;
      });

      // Insert overlay after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      });
    }
  }

  // Handle category selection from dropdown
  void _onCategorySelected(BrandCategory category) {
    _removeOverlay();
    _scrollToCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: brandsAsync.when(
        data: (brands) {
          // Update brands data
          _updateBrandsData(brands);

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // AppBar
              SliverAppBar(
                backgroundColor: AppColors.secondaryHighlightColor,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                floating: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.router.pop(), // Pop doesn't need throttling typically, keeping as is or changing if needed. Usually only push needs throttling against double clicks.
                  // Actually user issue mentions "returning" to same page. This usually happens if they pushed twice. 
                  // If they double click BACK, they might pop twice. But pop is usually safe or handled by stack.
                  // The issue: "enter subpage, want to return, keeps returning to same page" -> implies multiple pushes of subpage.
                  // So we only fix pushes.
                ),
                title: const Text(
                  '公益商家',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),

              // Pinned category buttons
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategoryButtonsDelegate(
                  categories: _availableCategories,
                  selectedCategory: _selectedCategory,
                  onCategoryTap: _scrollToCategory,
                  isDropdownOpen: _isDropdownOpen,
                  onToggleDropdown: _toggleDropdown,
                  onCategorySelected: _onCategorySelected,
                ),
              ),

              // Brand sections by category
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = _availableCategories[index];
                    final categoryBrands = _brandsByCategory[category] ?? [];

                    return _CategorySection(
                      key: _categoryKeys[category],
                      category: category,
                      brands: categoryBrands,
                    );
                  },
                  childCount: _availableCategories.length,
                ),
              ),

              // Bottom padding to allow last category to scroll to top
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 116 + 10,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryHighlightColor,
            )
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('載入商家失敗: ${ErrorMessages.getDisplayMessage(error.toString())}'),
            ],
          ),
        ),
      ),
    );
  }
}

// Persistent header delegate for category buttons
class _CategoryButtonsDelegate extends SliverPersistentHeaderDelegate {
  final List<BrandCategory> categories;
  final BrandCategory selectedCategory;
  final Function(BrandCategory) onCategoryTap;
  final bool isDropdownOpen;
  final VoidCallback onToggleDropdown;
  final Function(BrandCategory) onCategorySelected;

  _CategoryButtonsDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.isDropdownOpen,
    required this.onToggleDropdown,
    required this.onCategorySelected,
  });

  @override
  double get minExtent => 46; // (30px 內容 + 上下各 8px padding)

  @override
  double get maxExtent => 46;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                    // Category buttons or placeholder text
                    Positioned.fill(
                      child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isDropdownOpen
                          ? Container()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                              key: const ValueKey('categories'),
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: categories.map((category) {
                                  final isSelected = category == selectedCategory;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () => onCategoryTap(category),
                                      child: Container(
                                        width: 80,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryHighlightColor
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primaryHighlightColor
                                                : AppColors.greyBackground,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          category.displayName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isSelected ? Colors.white : Color(0xFF808080),
                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                                            height: 1.16, // 垂直置中輔助修正
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ),
                    ),
                    // Dropdown arrow at the right
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 1,
                      child: GestureDetector(
                        onTap: onToggleDropdown,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.center,
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 1.0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                              color: Colors.black54,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.greyBackground),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryButtonsDelegate oldDelegate) {
    return oldDelegate.selectedCategory != selectedCategory ||
        oldDelegate.isDropdownOpen != isDropdownOpen;
  }
}

// Category section widget
class _CategorySection extends StatelessWidget {
  final BrandCategory category;
  final List<Brand> brands;

  const _CategorySection({
    super.key,
    required this.category,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Text(
            category.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Brands wrap layout
          Wrap(
            spacing: 22,
            runSpacing: 22,
            children: brands.map((brand) {
              // Calculate width for 4 columns
              final totalContainerWidth = MediaQuery.of(context).size.width - 48;
              const crossAxisCount = 4;
              const spacing = 22.0;
              final itemWidth = (totalContainerWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

              return SizedBox(
                width: itemWidth,
                child: _BrandGridItem(brand: brand),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Brand grid item widget
class _BrandGridItem extends StatelessWidget {
  final Brand brand;

  const _BrandGridItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.pushThrottledWithTracking(MerchantDetailRoute(brand: brand));
      },
      child: Column(
        children: [
          // Brand logo
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.appBackgroundColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: brand.logoUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.greyBackground,
                    child: Icon(Icons.store, size: 24, color: Colors.grey[400]),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.greyBackground,
                    child: Icon(Icons.store, size: 24, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Brand name
          SizedBox(
            height: 16,
            child: OverflowBox(
              maxWidth: 84,
              minWidth: 84,
              child: Text(
                brand.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryValueColor,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
