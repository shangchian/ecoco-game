import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/colors.dart';
import '../router/app_router.dart';
import '/providers/brand_provider.dart';
import '/models/brand_model.dart';
import '../ecoco_icons.dart';
import '/utils/router_analytics_extension.dart';

class PopularMerchantsSection extends ConsumerStatefulWidget {
  const PopularMerchantsSection({super.key});

  @override
  ConsumerState<PopularMerchantsSection> createState() =>
      _PopularMerchantsSectionState();
}

class _PopularMerchantsSectionState
    extends ConsumerState<PopularMerchantsSection> {
  @override
  void initState() {
    super.initState();
    // Initial preload
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brandsAsync = ref.read(premiumBrandsProvider);
      brandsAsync.whenData((brands) {
        _preloadBrandImages(brands);
      });
    });
  }

  void _preloadBrandImages(List<Brand> brands) {
    if (!mounted) return;

    // Limit to first 6 items for bandwidth optimization (visible area)
    final targetBrands = brands.take(5);

    for (final brand in targetBrands) {
      final url = brand.logoUrl;
      if (url != null && url.isNotEmpty) {
        if (mounted) {
          precacheImage(CachedNetworkImageProvider(url), context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final premiumBrandsAsync = ref.watch(premiumBrandsProvider);

    // Listen for data updates
    ref.listen<AsyncValue<List<Brand>>>(premiumBrandsProvider,
        (previous, next) {
      next.whenData((brands) {
        _preloadBrandImages(brands);
      });
    });

    return premiumBrandsAsync.when(
      data: (brands) => _buildContent(context, brands),
      loading: () => _buildLoading(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context, List<Brand> brands) {
    if (brands.isEmpty) return const SizedBox.shrink();

    return Container(
      color: AppColors.appBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          ECOCOIcons.storefront,
                          size: 18,
                          color: Color(0xFF333333),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '熱門商家',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      context.router.pushThrottledWithTracking(const MerchantListRoute());
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '更多商家',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.loginTextbutton,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AppColors.loginTextbutton,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal scrolling brands
          SizedBox(
            height: 106,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: GestureDetector(
                    onTap: () {
                      context.router.pushThrottledWithTracking(
                          MerchantDetailRoute(brand: brand));
                    },
                    child: Column(
                      children: [
                        // Brand logo
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 2, left: 2, right: 2, top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: brand.logoUrl ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  _buildPlaceholder(),
                              errorWidget: (context, url, error) =>
                                  _buildPlaceholder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Brand name
                        SizedBox(
                          width: 74,
                          child: MediaQuery(
                            // 鎖定字體比例，無論手機字體大小設多少這塊文字都維持預設大小
                            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                            child: Text(
                              brand.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.white,
      child: Icon(
        ECOCOIcons.storefront,
        size: 32,
        color: Color(0xFFB3B3B3),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 140,
      color: Colors.white,
      child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          )
      ),
    );
  }
}
