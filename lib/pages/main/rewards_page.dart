import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/models/coupon_status_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoco_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/snackbar_helper.dart';
import '/l10n/app_localizations.dart';
import '/widgets/sort_buttons.dart';
import '/widgets/merchant_reward_card.dart';
import '/widgets/featured_reward_card.dart';
import '/widgets/popular_merchants_section.dart';
import '/models/coupon_rule.dart';
import '/models/coupon_rule_extensions.dart';
import '/providers/coupon_rules_provider.dart';
import '/providers/auth_provider.dart';
import '/widgets/ecoco_points_badge.dart';
import '/providers/wallet_provider.dart';
import '/providers/brand_provider.dart';
import '/ecoco_icons.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class RewardsPage extends ConsumerStatefulWidget {
  const RewardsPage({super.key});

  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends ConsumerState<RewardsPage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _featuredScrollController = ScrollController();
  SortType _selectedSort = SortType.comprehensive;
  FilterOptions? _filterOptions;
  bool _showBackToTop = false;
  double _lastScrollOffset = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _featuredScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial data sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final repository = ref.read(couponRulesRepositoryProvider);
      final brandRepository = ref.read(brandRepositoryProvider);

      // Sync rules (check etag)
      repository.syncCouponRules();
      brandRepository.syncBrands();

      // Sync statuses and wallet if logged in
      final authData = ref.read(authProvider);
      if (authData != null) {
        repository.syncCouponStatuses();
        ref.read(walletProvider.notifier).fetchWalletData();
      }

      // Initial preload if data is already available
      final activeCoupons = ref.read(activeCouponRulesWithStatusProvider);
      activeCoupons.whenData((coupons) {
        _preloadFeaturedImages(coupons);
      });
    });
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Refresh coupon rules and status data
  Future<void> _onRefresh() async {
    final authData = ref.read(authProvider);
    if (authData == null) return;

    final repository = ref.read(couponRulesRepositoryProvider);

    try {
      // Refresh both coupon rules and status in parallel
      await Future.wait([
        repository.syncCouponRules(forceRefresh: true),
        repository.syncCouponStatuses(),
        ref.read(walletProvider.notifier).fetchWalletData(),
        ref.read(brandRepositoryProvider).syncBrands(forceRefresh: true),
      ]).timeout(const Duration(seconds: 10)); // Add timeout to prevent hanging
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

  void _preloadFeaturedImages(List<CouponRule> coupons) {
    if (!mounted) return;

    // Filter featured and active coupons
    final featuredCoupons = coupons
        .where((c) => c.isFeatured && c.isAvailable)
        .toList();

    // Limit to first 5 items for bandwidth optimization
    final targetCoupons = featuredCoupons.take(3);

    for (final coupon in targetCoupons) {
      final url = coupon.cardImageUrl;
      if (url != null && url.isNotEmpty) {
        // Use CachedNetworkImageProvider to preload
        if (mounted) {
          precacheImage(CachedNetworkImageProvider(url), context);
        }
      }
    }
  }

  /// Apply sort and filter logic to coupon list
  List<CouponRule> _applySortAndFilter(
    List<CouponRule> coupons,
    SortType sortType,
    FilterOptions? filterOptions,
  ) {
    var result = List<CouponRule>.from(coupons);

    // Apply filters first
    if (filterOptions != null) {
      // Category filter
      if (filterOptions.category != null) {
        final targetCategory = filterOptions.category!.toCouponCategory;
        if (targetCategory != null) {
          result = result
              .where((c) => c.categoryCode == targetCategory)
              .toList();
        }
      }

      // Points range filter
      if (filterOptions.pointsRange != null) {
        result = result.where((c) {
          final price = c.unitPrice;
          switch (filterOptions.pointsRange!) {
            case PointsRange.range1To100:
              return price >= 1 && price <= 100;
            case PointsRange.range101To200:
              return price >= 101 && price <= 200;
            case PointsRange.range201To300:
              return price >= 201 && price <= 300;
            case PointsRange.range301To400:
              return price >= 301 && price <= 400;
            case PointsRange.range401To500:
              return price >= 401 && price <= 500;
            case PointsRange.rangeAbove500:
              return price > 500;
          }
        }).toList();
      }

      // County filter (geofenceAreaIds)
      if (filterOptions.countyId != null) {
        final countyIdStr = filterOptions.countyId.toString();
        result = result
            .where(
              (c) =>
                  //c.geofenceAreaIds.isEmpty || // No restriction
                  c.geofenceAreaIds.contains(countyIdStr),
            )
            .toList();
      }
    }

    // Apply sorting
    switch (sortType) {
      case SortType.comprehensive:
        // Use sortOrder from API (already sorted by default)
        result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        break;

      case SortType.newest:
        // Sort by lastUpdatedAt descending
        result.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
        break;

      case SortType.pointsAscending:
        // Sort by unitPrice ascending
        result.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
        break;

      case SortType.pointsDescending:
        // Sort by unitPrice descending
        result.sort((a, b) => b.unitPrice.compareTo(a.unitPrice));
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final activeCouponsAsync = ref.watch(activeCouponRulesWithStatusProvider);
    final walletData = ref.watch(walletProvider);
    final userPoints = walletData?.ecocoWallet.currentBalance ?? 0;

    // Listen for data updates to preload new images
    ref.listen<AsyncValue<List<CouponRule>>>(
      activeCouponRulesWithStatusProvider,
      (previous, next) {
        next.whenData((coupons) {
          _preloadFeaturedImages(coupons);
        });
      },
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundYellow,
      body: activeCouponsAsync.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        data: (allActiveCoupons) {
          // Filter for featured section: isPremium && isActive
          final featuredCoupons = allActiveCoupons
              .where((c) => c.isFeatured)
              .toList();

          // Filter for more offers: isActive only
          final moreCoupons = _applySortAndFilter(
            allActiveCoupons.where((c) => c.isAvailable).toList(),
            _selectedSort,
            _filterOptions,
          );

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primaryHighlightColor,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // AppBar
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      backgroundColor: AppColors.backgroundYellow,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: 64,
                      title: Image.asset(
                        'assets/images/ecoco_logo_pure.png',
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                      centerTitle: false,
                      actions: [EcocoPointsBadge.detailed(points: userPoints)],
                    ),

                    // 熱門商家
                    const SliverToBoxAdapter(child: PopularMerchantsSection()),

                    // 精選優惠標題
                    if (featuredCoupons.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.appBackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          ECOCOIcons.star,
                                          size: 18,
                                          color: Color(0xFF333333),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          appLocale?.featuredOffers ?? '精選優惠',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // 精選優惠橫向滑動
                    if (featuredCoupons.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          color: AppColors.appBackgroundColor,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 6,
                                ),
                                margin: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: SizedBox(
                                  height: 232,
                                  child: ListView.builder(
                                    controller: _featuredScrollController,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    itemCount: featuredCoupons.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 140,
                                        height: 210,
                                        margin: EdgeInsets.only(
                                          right:
                                              index < featuredCoupons.length - 1
                                              ? 16
                                              : 0,
                                        ),
                                        child:
                                            FeaturedRewardCard.fromCouponRule(
                                              featuredCoupons[index],
                                              showBadges: true,
                                              onTap: () {
                                                final coupon =
                                                    featuredCoupons[index];
                                                // Navigate to exchange page
                                                context.router.pushThrottledWithTracking(
                                                  MerchantRewardExchangeRoute(
                                                    couponRule: coupon,
                                                    userPoints: userPoints,
                                                  ),
                                                );
                                              },
                                            ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              /*_CustomScrollIndicator(
                        controller: _featuredScrollController,
                      ),*/
                            ],
                          ),
                        ),
                      ),

                    // 更多優惠標題 + 排序按鈕
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.appBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        ECOCOIcons.ticketFolder,
                                        size: 21,
                                        color: Color(0xFF333333),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        appLocale?.moreOffers ?? '更多優惠',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 236,
                                height: 32,
                                child: SortButtons(
                                  selectedSort: _selectedSort,
                                  filterOptions: _filterOptions,
                                  onSortChanged: (sort) {
                                    setState(() {
                                      _selectedSort = sort;
                                    });
                                  },
                                  onFilterChanged: (options) {
                                    setState(() {
                                      _filterOptions = options;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 更多優惠網格佈局（Pinterest 風格）
                    DecoratedSliver(
                      decoration: const BoxDecoration(
                        color: AppColors.appBackgroundColor,
                      ),
                      sliver: SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 0; i < moreCoupons.length; i += 2)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: MerchantRewardCard.fromCouponRule(
                                          moreCoupons[i],
                                          onTap: () {
                                            if (moreCoupons[i].displayStatus ==
                                                    DisplayStatus.normal ||
                                                moreCoupons[i].displayStatus ==
                                                    DisplayStatus.soldOut) {
                                              context.router.pushThrottledWithTracking(
                                                MerchantRewardExchangeRoute(
                                                  couponRule: moreCoupons[i],
                                                  userPoints: userPoints,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 1; i < moreCoupons.length; i += 2)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: MerchantRewardCard.fromCouponRule(
                                          moreCoupons[i],
                                          onTap: () {
                                            if (moreCoupons[i].displayStatus ==
                                                    DisplayStatus.normal ||
                                                moreCoupons[i].displayStatus ==
                                                    DisplayStatus.soldOut) {
                                              context.router.pushThrottledWithTracking(
                                                MerchantRewardExchangeRoute(
                                                  couponRule: moreCoupons[i],
                                                  userPoints: userPoints,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 底部提示文字
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.appBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 180),
                          child: Center(
                            child: Text(
                              appLocale?.endOfList ?? '到底囉～敬請期待更多優惠',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('載入優惠券時發生錯誤', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
