import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/coupon_rule.dart';
import '../models/coupon_rule_extensions.dart';
import '../models/coupon_status_model.dart';
import '../ecoco_icons.dart';

/// Featured reward card widget for the rewards page featured section.
///
/// Displays a card design with:
/// - Square image (1:1 aspect ratio)
/// - Reward name or brand name
/// - Exchange rate with ECOCO icon
/// - PromoLabel badge (optional)
/// - NEW badge (optional)
///
/// This widget is similar to [MerchantRewardCard] but excludes the SOLD_OUT badge
/// for a cleaner featured presentation.
class FeaturedRewardCard extends StatelessWidget {
  /// The reward or brand name to display
  final String rewardName;

  /// URL or asset path for the background image
  final String backgroundImageUrl;

  /// Formatted exchange rate text (e.g., "100點 = 1組")
  final String exchangeRate;

  /// Optional promotional label text (max 6 characters)
  final String? promoLabel;

  /// Whether to show the NEW badge
  final bool showNewBadge;

  /// 是否顯示 SOLD_OUT 徽章（已兌換完畢）
  final bool showSoldOutBadge;

  /// Optional callback when card is tapped
  final VoidCallback? onTap;

  /// Optional height constraint for the card
  final double? height;

  const FeaturedRewardCard({
    super.key,
    required this.rewardName,
    required this.backgroundImageUrl,
    required this.exchangeRate,
    this.promoLabel,
    this.showNewBadge = false,
    this.showSoldOutBadge = false,
    this.onTap,
    this.height,
  });

  /// Create FeaturedRewardCard from CouponRule
  factory FeaturedRewardCard.fromCouponRule(
    CouponRule couponRule, {
    VoidCallback? onTap,
    double? height,
    bool showBadges = true,
  }) {
    // Calculate NEW badge - show if within 7 days of exchangeableStartAt
    final now = DateTime.now().toUtc();
    final daysSinceStart = now
        .difference(couponRule.exchangeableStartAt)
        .inDays;
    final isNew = daysSinceStart >= 0 && daysSinceStart < 7;

    // Process promo label - truncate to 6 characters max
    String? processedPromoLabel;
    if (couponRule.promoLabel != null && couponRule.promoLabel!.isNotEmpty) {
      final label = couponRule.promoLabel!.trim();
      processedPromoLabel = label.length > 6 ? label.substring(0, 6) : label;
    }

    // Check if sold out
    final isSoldOut = couponRule.displayStatus == DisplayStatus.soldOut;

    return FeaturedRewardCard(
      rewardName: couponRule.title.isNotEmpty
          ? couponRule.title
          : couponRule.brandName,
      backgroundImageUrl: couponRule.cardImageUrl ?? '',
      exchangeRate: couponRule.formattedExchangeRate,
      promoLabel: showBadges ? processedPromoLabel : null,
      showNewBadge: showBadges && isNew,
      showSoldOutBadge: showBadges && isSoldOut,
      onTap: onTap,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      clipBehavior: Clip.none, // 避免外層切掉光暈效果
      color: Colors.transparent,
      margin: const EdgeInsets.fromLTRB(2, 4, 2, 4),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      child: _buildCardContent(context),
    );

    return height != null
        ? SizedBox(height: height, child: cardContent)
        : cardContent;
  }

  /// Build the main card content
  Widget _buildCardContent(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section with NEW badge
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 2,  // 往外擴散光暈
                  spreadRadius: 2, // 追加擴散半徑
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    _buildBackgroundImage(),

                    // NEW badge (top-right corner)
                    if (showNewBadge)
                      Positioned(top: 0, right: 0, child: _NewBannerWidget()),
                    // PromoLabel badge
                    if (promoLabel != null)
                      Positioned(bottom: 0, left: 0, child: _PromoLabelBadgeWidget(text: promoLabel!)),
                    // 兌換完畢專用：白色半透明遮罩
                    if (showSoldOutBadge)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    // 兌換完畢專用：徽章圖片（顯示在遮罩上方）
                    if (showSoldOutBadge)
                      Positioned.fill(
                        child: Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // 圖片寬度為卡片寬度的 80%
                              final badgeWidth = constraints.maxWidth * 0.8;
                              return _RedeemedBadgeWidget(width: badgeWidth);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Bottom info section
          _buildBottomSection(context),
        ],
      ),
    );
  }

  /// Build the bottom information section
  Widget _buildBottomSection(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reward name
            Text(
              rewardName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Exchange rate row
            Row(
              children: [
                const Icon(
                  ECOCOIcons.ecocoSmileOutlined,
                  size: 16,
                  color: AppColors.primaryHighlightColor,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      exchangeRate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryHighlightColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build background image widget
  /// Automatically determines whether it's a network or asset image
  Widget _buildBackgroundImage() {
    // Check if it's a local asset image
    final isAsset = backgroundImageUrl.startsWith('assets/');

    if (isAsset) {
      // Use Image.asset for local images
      return Image.asset(
        backgroundImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.white,
          child: const Center(
            child: Icon(
              ECOCOIcons.ticketFolder,
              size: 48,
              color: Color(0xFFB3B3B3),
            ),
          ),
        ),
      );
    } else {
      // Use CachedNetworkImage for network images
      return CachedNetworkImage(
        imageUrl: backgroundImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryHighlightColor,
              )
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.white,
          child: const Center(
            child: Icon(
              ECOCOIcons.ticketFolder,
              size: 48,
              color: Color(0xFFB3B3B3),
            ),
          ),
        ),
      );
    }
  }
}

/// NEW banner widget (right top corner ribbon)
class _NewBannerWidget extends StatelessWidget {
  const _NewBannerWidget();

  @override
  Widget build(BuildContext context) {
    const size = 39.0;

    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/new_ribbon.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// 兌換完畢徽章元件（中央覆蓋圖片設計）
class _RedeemedBadgeWidget extends StatelessWidget {
  final double width;

  const _RedeemedBadgeWidget({required this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/redeemed_cover.png',
      width: width,
      fit: BoxFit.contain,
    );
  }
}

/// PromoLabel badge widget (with image background)
class _PromoLabelBadgeWidget extends StatelessWidget {
  final String text;

  const _PromoLabelBadgeWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    const badgeWidth = 105.0;
    const badgeHeight = 20.0;

    return SizedBox(
      width: badgeWidth,
      height: badgeHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/promo_label_tag_2.png',
            width: badgeWidth,
            height: badgeHeight,
            fit: BoxFit.fill,
          ),
          // White text overlay (centered)
          Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
