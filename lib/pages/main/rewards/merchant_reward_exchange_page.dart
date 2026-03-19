import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoco_app/utils/error_messages.dart';
import 'package:dio/dio.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/widgets/daka_coin_icon.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/wallet_provider.dart';
import '../../../widgets/ntp_coin_icon.dart';
import '../../../widgets/ntp_points_badge.dart';
import '/models/coupon_rule.dart';
import '/models/coupon_rule_extensions.dart';
import '/models/member_limits_response.dart';
import '/database/converters/carousel_list_converter.dart';
import '/ecoco_icons.dart';
import '/providers/members_service_provider.dart';
import '/providers/auth_provider.dart';
import '/services/online/base_service.dart';
import '/router/app_router.dart';
import '/widgets/ecoco_points_badge.dart';
import '/widgets/daka_points_badge.dart';
import '/pages/common/loading_overlay.dart';
import '/utils/router_analytics_extension.dart';

/// 商家優惠兌換頁面（查看優惠詳情）
@RoutePage()
class MerchantRewardExchangePage extends ConsumerStatefulWidget {
  final CouponRule couponRule;
  final int userPoints; // 使用者當前點數

  const MerchantRewardExchangePage({
    super.key,
    required this.couponRule,
    this.userPoints = 0,
  });

  @override
  ConsumerState<MerchantRewardExchangePage> createState() =>
      _MerchantRewardExchangePageState();
}

class _MerchantRewardExchangePageState
    extends ConsumerState<MerchantRewardExchangePage> {
  late PageController _pageController;
  int _currentPage = 0;

  // Carousel items from CouponRule
  late List<CarouselItem> _carouselItems;
  late bool _useFallbackImage;

  // Markdown content states
  String? _rulesSummaryContent;
  String? _redemptionTermsContent;
  bool _isLoadingRulesSummary = false;
  bool _isLoadingRedemptionTerms = false;
  String? _rulesSummaryError;
  String? _redemptionTermsError;

  // Member limits states
  bool _isLoadingMemberLimits = true;
  MemberLimitsResponse? _memberLimits;
  String? _memberLimitsErrorMessage; // API 錯誤訊息

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Refresh wallet data to ensure points are up to date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).fetchWalletData();
    });
    // Get active carousel items from coupon rule
    _carouselItems = widget.couponRule.activeCarouselItems;
    // Fallback to cardImageUrl if no carousel
    _useFallbackImage = _carouselItems.isEmpty;
    // Load markdown content
    _loadRulesSummary();
    _loadRedemptionTerms();
    // Load member limits
    _loadMemberLimits();
    // Track page view
    FirebaseAnalytics.instance.logEvent(
      name: 'view_item',
      parameters: {
        'item_id': widget.couponRule.id,
        'item_name': widget.couponRule.title,
      },
    );
    // Start auto-play
    _startAutoPlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images for smoother carousel experience
    if (!_useFallbackImage) {
      for (final item in _carouselItems) {
        if (item.mediaType == 'STATIC_IMAGE' && item.mediaUrl.isNotEmpty) {
           precacheImage(CachedNetworkImageProvider(item.mediaUrl), context);
        } else if (item.fallbackUrl != null && item.fallbackUrl!.isNotEmpty) {
           // Pre-cache fallback image for other media types
           precacheImage(CachedNetworkImageProvider(item.fallbackUrl!), context);
        }
      }
    } else if (widget.couponRule.cardImageUrl != null && widget.couponRule.cardImageUrl!.isNotEmpty) {
      precacheImage(CachedNetworkImageProvider(widget.couponRule.cardImageUrl!), context);
    }
  }

  // Timer for carousel auto-play
  Timer? _carouselTimer;

  void _startAutoPlay() {
    _carouselTimer?.cancel();
    if (_carouselItems.length > 1) {
      _carouselTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
        if (_pageController.hasClients) {
          int nextPage = _currentPage + 1;
          if (nextPage >= _carouselItems.length) {
            nextPage = 0;
          }

          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _stopAutoPlay() {
    _carouselTimer?.cancel();
  }

  /// 載入會員兌換限制狀態
  Future<void> _loadMemberLimits() async {
    try {
      final authData = ref.read(authProvider);
      if (authData == null) return;
      final membersService = ref.read(membersServiceProvider);
      final response = await membersService.getMemberLimits(
        couponRuleId: widget.couponRule.id,
      );

      if (mounted) {
        setState(() {
          _memberLimits = response;
          _memberLimitsErrorMessage = null;
          _isLoadingMemberLimits = false;
        });
      }
    } on ApiException catch (e) {
      // API 回傳錯誤碼時，顯示錯誤訊息在按鈕上
      if (mounted) {
        setState(() {
          _memberLimits = null;
          _memberLimitsErrorMessage = e.message;
          _isLoadingMemberLimits = false;
        });
      }
    } catch (e) {
      // 其他錯誤時預設為可兌換，避免阻擋用戶
      if (mounted) {
        setState(() {
          _memberLimits = null;
          _memberLimitsErrorMessage = null;
          _isLoadingMemberLimits = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadRulesSummary() async {
    if (widget.couponRule.rulesSummaryMdUrl.isEmpty) return;

    setState(() {
      _isLoadingRulesSummary = true;
      _rulesSummaryError = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        widget.couponRule.rulesSummaryMdUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status == 200,
        ),
      );

      if (mounted) {
        setState(() {
          _rulesSummaryContent = response.data as String;
          _isLoadingRulesSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _rulesSummaryError = '載入兌換說明失敗';
          _isLoadingRulesSummary = false;
        });
      }
    }
  }

  Future<void> _loadRedemptionTerms() async {
    if (widget.couponRule.redemptionTermsMdUrl.isEmpty) return;

    setState(() {
      _isLoadingRedemptionTerms = true;
      _redemptionTermsError = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        widget.couponRule.redemptionTermsMdUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status == 200,
        ),
      );

      if (mounted) {
        setState(() {
          _redemptionTermsContent = response.data as String;
          _isLoadingRedemptionTerms = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _redemptionTermsError = '載入注意事項失敗';
          _isLoadingRedemptionTerms = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  /// 處理前往兌換按鈕
  void _handleGoToExchange() {
    final walletData = ref.read(walletProvider);
    final currentPoints = widget.couponRule.currencyCode == CurrencyCode.ecocoPoint
        ? walletData?.ecocoWallet.currentBalance ?? widget.userPoints
        : widget.couponRule.currencyCode == CurrencyCode.daka
            ? walletData?.dakaWallet.currentBalance ?? widget.userPoints
            : walletData?.ntpWallet.currentBalance ?? widget.userPoints;

    context.router.pushThrottledWithTracking(
      MerchantRewardExchangeConfirmRoute(
        couponRule: widget.couponRule,
        userPoints: currentPoints,
        maxExchangeableUnits: _memberLimits?.maxExchangeableUnits,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              // 可滾動內容區
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商家資訊區
                    _buildMerchantInfo(),

                    const Divider(height: 4, thickness: 4, color: Color(0xFFF0F0F0)),

                    // 兌換說明區
                    _buildExchangeRules(),

                    const Divider(height: 4, thickness: 4, color: Color(0xFFF0F0F0)),

                    // 注意事項區
                    _buildExchangeNotes(),

                    const SizedBox(height: 100), // 留空間給底部按鈕，避免內容被遮住
                  ],
                ),
              ),

              // 底部「前往兌換」按鈕 - 疊加在內容上方
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: _buildBottomButton(),
              ),
            ],
          ),
        ),
        if (_isLoadingMemberLimits) const LoadingOverlay(),
      ],
    );
  }

  /// 頂部 AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundYellow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 56,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.router.maybePop(),
      ),
      title: Text(
        widget.couponRule.currencyCode == CurrencyCode.ntp
            ? '新北市限定'
            : '查看優惠',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
      actions: [
        // 使用者點數顯示
        Consumer(
          builder: (context, ref, child) {
            final walletData = ref.watch(walletProvider);
            final currentPoints = widget.couponRule.currencyCode == CurrencyCode.ecocoPoint
                ? walletData?.ecocoWallet.currentBalance ?? widget.userPoints
                : widget.couponRule.currencyCode == CurrencyCode.daka
                    ? walletData?.dakaWallet.currentBalance ?? widget.userPoints
                    : walletData?.ntpWallet.currentBalance ?? widget.userPoints;

            if (widget.couponRule.currencyCode == CurrencyCode.daka) {
              return DakaPointsBadge.detailed(
                points: currentPoints,
              );
            } else if (widget.couponRule.currencyCode == CurrencyCode.ntp) {
              return NtpPointsBadge.detailed(
                points: currentPoints,
              );
            }

            return EcocoPointsBadge.detailed(
              points: currentPoints,
            );
          },
        ),
      ],
    );
  }

  /// 圖片輪播區
  Widget _buildImageCarousel() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.couponBgColor, // 綠色背景（暫時）
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 179,
        child: Stack(
          children: [
            // 圖片輪播
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _useFallbackImage ? 1 : _carouselItems.length,
              itemBuilder: (context, index) {
                if (_useFallbackImage) {
                  return CachedNetworkImage(
                    imageUrl: widget.couponRule.cardImageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryHighlightColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.couponBgColor,
                      child: const Center(
                        child: Icon(
                          ECOCOIcons.ticketFolder,
                          size: 64,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  );
                }

                final item = _carouselItems[index];
                switch (item.mediaType) {
                  case 'STATIC_IMAGE':
                    return CachedNetworkImage(
                      imageUrl: item.mediaUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryHighlightColor,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        // Try fallback URL
                        if (item.fallbackUrl != null && item.fallbackUrl!.isNotEmpty) {
                          return CachedNetworkImage(
                            imageUrl: item.fallbackUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              color: AppColors.couponBgColor,
                              child: const Center(
                                child: Icon(
                                  ECOCOIcons.ticketFolder,
                                  size: 64,
                                  color: AppColors.thirdValueColor,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
                          color: AppColors.couponBgColor,
                          child: const Center(
                            child: Icon(
                              ECOCOIcons.ticketFolder,
                              size: 64,
                              color: AppColors.thirdValueColor,
                            ),
                          ),
                        );
                      },
                    );
                  case 'VIDEO':
                  case 'LOTTIE':
                  case 'LOOPING_ANIMATION':
                    // Show fallback preview if available
                    if (item.fallbackUrl != null && item.fallbackUrl!.isNotEmpty) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.fallbackUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryHighlightColor,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                          // Optional: Overlay to indicate media type (can be removed if pure preview desired)
                          Container(
                            color: Colors.black.withValues(alpha: 0.1),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 48,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    // Default placeholder if no fallback
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('媒體類型即將支援', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  default:
                    return Container(
                      color: AppColors.couponBgColor,
                      child: const Center(
                        child: Icon(
                          ECOCOIcons.ticketFolder,
                          size: 64,
                          color: AppColors.thirdValueColor,
                        ),
                      ),
                    );
                }
              },
            ),

            // 輪播指示器
            if (!_useFallbackImage && _carouselItems.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _carouselItems.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 10 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _currentPage == index
                            ? Colors.white
                            : AppColors.thirdValueColor,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(1, 1),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 商家資訊區
  Widget _buildMerchantInfo() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 上半部有 padding 的區域
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                // 圖片輪播區
                _buildImageCarousel(),

                const SizedBox(height: 4),

                // 優惠券名稱
                Center(
                  child: Text(
                    widget.couponRule.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 4),
              ],
            ),
          ),

          // 全寬 Divider（不受 padding 影響）
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // 下半部有 padding 的區域
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 4,
            ),
            child: Column(
              children: [
                const SizedBox(height: 4),

                // 兌換資訊行
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 兌換比例 Column
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.couponRule.currencyCode ==
                                    CurrencyCode.daka)
                                  DakaCoinIcon(
                                      isEnabled: true, size: 28, filled: true)
                                else
                                  if (widget.couponRule.currencyCode ==
                                      CurrencyCode.ntp)
                                    NtpCoinIcon(
                                        isEnabled: true, size: 28, filled: true)
                                  else
                                    Icon(ECOCOIcons.ecocoSmileOutlined, size: 28, color: AppColors.primaryHighlightColor),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    widget.couponRule.formattedExchangeRate,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 間距
                    const SizedBox(width: 20),

                    // 限制說明 Column
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  ECOCOIcons.warning,
                                  size: 23,
                                  color: AppColors.primaryHighlightColor,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    (widget.couponRule.shortNotice == null ||
                                        widget.couponRule.shortNotice!
                                            .trim()
                                            .isEmpty)
                                        ? '使用詳情如下'
                                        : widget.couponRule.shortNotice!,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 兌換說明區
  Widget _buildExchangeRules() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活動期間（只有當 exchangeableStartAt 和 exchangeableEndAt 都有值時才顯示）
          if (widget.couponRule.exchangeableEndAt != null) ...[
            Text(
              '活動期間：${_formatDate(widget.couponRule.exchangeableStartAt)} ~ ${_formatDate(widget.couponRule.exchangeableEndAt!)}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryHighlightColor,
              ),
            ),
            const SizedBox(height: 12),
          ],
          // 兌換說明標題
          const Text(
            '兌換說明',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // 兌換說明 Markdown 內容
          _buildRulesSummaryContent(),
        ],
      ),
    );
  }

  /// 注意事項區
  Widget _buildExchangeNotes() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 注意事項標題
          const Text(
            '注意事項',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // 注意事項 Markdown 內容
          _buildRedemptionTermsContent(),
        ],
      ),
    );
  }

  /// 兌換說明 Markdown 內容
  Widget _buildRulesSummaryContent() {
    if (_isLoadingRulesSummary) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      );
    }

    if (_rulesSummaryError != null) {
      return Text(
        _rulesSummaryError!,
        style: const TextStyle(color: Colors.red, fontSize: 14),
      );
    }

    if (_rulesSummaryContent != null && _rulesSummaryContent!.isNotEmpty) {
      return Markdown(
        data: _rulesSummaryContent!,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onTapLink: (text, href, title) async {
          if (href != null) {
            final uri = Uri.parse(href);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri,
                  mode: LaunchMode.externalApplication);
            }
          }
        },
      );
    }

    // Fallback 到原本的 exchangeDisplayText
    return Text(
      '無兌換說明',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  /// 注意事項 Markdown 內容
  Widget _buildRedemptionTermsContent() {
    if (_isLoadingRedemptionTerms) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      );
    }

    if (_redemptionTermsError != null) {
      return Text(
        _redemptionTermsError!,
        style: const TextStyle(color: Colors.red, fontSize: 14),
      );
    }

    if (_redemptionTermsContent != null && _redemptionTermsContent!.isNotEmpty) {
      return Markdown(
        data: _redemptionTermsContent!,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onTapLink: (text, href, title) async {
          if (href != null) {
            final uri = Uri.parse(href);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri,
                  mode: LaunchMode.externalApplication);
            }
          }
        },
      );
    }

    // Fallback - 顯示提示文字
    return const Text(
      '無注意事項',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  /// 底部「前往兌換」按鈕
  Widget _buildBottomButton() {
    // 判斷是否可兌換
    // 1. 如果有 API 錯誤訊息，則不可兌換
    // 2. 否則根據 API 回傳的 isExchangeable 判斷
    // 3. 如果 API 失敗且無錯誤訊息（網路錯誤等），預設為可兌換
    final hasApiError = _memberLimitsErrorMessage != null;
    final isExchangeable = !hasApiError && (_memberLimits?.isExchangeable ?? false);

    // 按鈕文字優先順序：API 錯誤訊息 > reasonMessage > 預設文字
    final String buttonText;
    if (hasApiError) {
      buttonText = ErrorMessages.getDisplayMessage(_memberLimitsErrorMessage!);
    } else if (isExchangeable) {
      buttonText = '前往兌換';
    } else {
      buttonText = _memberLimits?.reasonMessage ?? '無法兌換';
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 1.0),
          ],
        ),
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 0,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: isExchangeable ? _handleGoToExchange : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryHighlightColor,
              disabledBackgroundColor: AppColors.disabledButtomBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
