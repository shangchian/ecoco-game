import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/coupon_rule.dart';
import '../models/coupon_rule_extensions.dart';
import '../models/coupon_status_model.dart';
import '../ecoco_icons.dart';

/// 商家優惠卡片元件
///
/// 支援多個獨立徽章同時顯示：
/// - promoLabel: 促銷標籤（左下角）
/// - NEW: 全新上線（右上角）
/// - SOLD_OUT: 已兌換完畢（中央覆蓋圖+灰階效果）
class MerchantRewardCard extends StatelessWidget {
  /// 商家名稱
  final String merchantName;

  /// 優惠券名稱（可選，如果未提供則使用 merchantName）
  final String? rewardName;

  /// 商家背景圖 URL
  final String backgroundImageUrl;

  /// 優惠類型（例如：「兌換券」、「折抵現金」）
  final String rewardType;

  /// 兌換方式（例如：「50點 = 1組」、「2點 = $1」）
  final String exchangeRate;

  /// 促銷標籤文字（最多6個字）
  final String? promoLabel;

  /// 是否顯示 NEW 徽章
  final bool showNewBadge;

  /// 是否顯示 SOLD_OUT 徽章（已兌換完畢）
  final bool showSoldOutBadge;

  /// 點擊回調函數
  final VoidCallback? onTap;

  /// 卡片高度（可選，若未指定則使用內容自適應高度）
  final double? height;

  const MerchantRewardCard({
    super.key,
    required this.merchantName,
    this.rewardName,
    required this.backgroundImageUrl,
    required this.rewardType,
    required this.exchangeRate,
    this.promoLabel,
    this.showNewBadge = false,
    this.showSoldOutBadge = false,
    this.onTap,
    this.height,
  });

  /// 從 CouponRule 建立卡片
  factory MerchantRewardCard.fromCouponRule(
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

    return MerchantRewardCard(
      merchantName: couponRule.brandName,
      rewardName: couponRule.title,
      backgroundImageUrl: couponRule.cardImageUrl ?? '',
      rewardType: couponRule.displayUnit,
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
    final cardContent = Container(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4), // 增加 margin 給光暈擴散空間
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 3,  // 往外擴散光暈
            spreadRadius: 3, // 追加擴散半徑
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0, // 取消原本的陰影
        child: _buildCardContent(),
      ),
    );

    // 如果有指定高度，則使用 SizedBox 包裝
    final sizedCard = height != null
        ? SizedBox(height: height, child: cardContent)
        : cardContent;

    // 直接返回卡片（兌換完畢的遮罩效果在圖片區域內處理）
    return sizedCard;
  }

  /// 建立背景圖片元件
  /// 自動判斷是網路圖片還是本地 asset 圖片
  Widget _buildBackgroundImage() {
    // 判斷是否為本地 assets 圖片
    final isAsset = backgroundImageUrl.startsWith('assets/');

    if (isAsset) {
      // 使用 Image.asset 載入本地圖片
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Image.asset(
          backgroundImageUrl,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 48,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    } else {
      // 使用 CachedNetworkImage 載入網路圖片
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: CachedNetworkImage(
          imageUrl: backgroundImageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.white,
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
                color: Color(0xffb2b2b2),
              ),
            ),
          ),
        ),
      );
    }
  }

  /// 建立卡片內容
  Widget _buildCardContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bottomWidget = Stack(
          children: [
            MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 促銷標籤專用
                    if (promoLabel != null)
                      _PromoLabelBadgeWidget(text: promoLabel ?? ""),
                    SizedBox(height: promoLabel != null ? 8 : 0),
                    // 優惠券名稱（使用 rewardName，若無則用 merchantName）
                    Text(
                      rewardName ?? merchantName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // 優惠資訊行
                    Row(
                      children: [
                        // ECOCO 點數圖示 - 保持固定大小
                        const Icon(
                          ECOCOIcons.ecocoSmileOutlined,
                          size: 16,
                          color: AppColors.primaryHighlightColor,
                        ),
                        const SizedBox(width: 4),
                        // 兌換方式 - 使用 Flexible 讓它可以彈性調整
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
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
            ),
            // 兌換完畢專用：白色半透明遮罩
            /*if (showSoldOutBadge)
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.5)),
              ),*/
          ],
        );

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 圖片區域（使用 AspectRatio 保持寬高比）
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                child: AspectRatio(
                  aspectRatio: 1,
                  //showBadge ? 133 / 140 : 120 / 125, // 約 1.6:1 的寬高比，可根據需要調整
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 背景圖片
                      _buildBackgroundImage(),
                      // 全新上線專用：右上角 NEW 繃帶
                      if (showNewBadge)
                        Positioned(top: 0, right: 0, child: _NewBannerWidget()),
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
              const Divider(
                    thickness: 2,
                    height: 0,
                    color: AppColors.dividerColor,
                  ),

              const SizedBox(height: 6),

              // 底部資訊區域（包含徽章、優惠券名稱和優惠資訊）
              if (constraints.hasBoundedHeight)
                Expanded(child: bottomWidget)
              else
                bottomWidget,
            ],
          ),
        );
      },
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

/// NEW 繃帶元件（右上角圖片）
class _NewBannerWidget extends StatelessWidget {
  const _NewBannerWidget();

  @override
  Widget build(BuildContext context) {
    const size = 39.0; // Size to display the ribbon image

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

/// 促銷標籤徽章元件（左下角，動態寬度）
class _PromoLabelBadgeWidget extends StatelessWidget {
  final String text;

  const _PromoLabelBadgeWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    const maxWidth = 92.0;
    const height = 20.0;
    const tagEndAspectRatio = 512 / 1204; // 原圖比例
    const tagEndWidth = height * tagEndAspectRatio; // ≈ 8.5

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 左側文字區塊（橘色背景，左側圓角）
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryHighlightColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    bottomLeft: Radius.circular(2),
                  ),
                ),
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Center(
                  widthFactor: 1.0,
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
              ),
            ),
            // 右側尾端圖片
            Image.asset(
              'assets/images/tag_end.png',
              height: height,
              width: tagEndWidth,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
