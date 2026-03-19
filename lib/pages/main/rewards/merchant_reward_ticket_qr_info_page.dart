import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/voucher_model.dart';
import '../../../widgets/daka_coin_icon.dart';
import '../../../widgets/ntp_coin_icon.dart';
import '/ecoco_icons.dart';
import '/models/coupon_rule.dart';
import '/models/coupon_rule_extensions.dart';
import '/models/member_coupon_model.dart';
import '/models/member_coupon_with_rule.dart';
import '/providers/brand_provider.dart';
import '/providers/voucher_wallet_provider.dart';
import '/router/app_router.dart';
import '/utils/router_analytics_extension.dart';

/// QR Code 票券說明頁，提供「出示條碼」導向
@RoutePage()
class MerchantRewardTicketQrInfoPage extends ConsumerStatefulWidget {
  final CouponRule couponRule;
  final String memberCouponId;
  final int userPoints;
  final VoucherStatus initialStatus;

  const MerchantRewardTicketQrInfoPage({
    super.key,
    required this.couponRule,
    required this.memberCouponId,
    this.userPoints = 0,
    this.initialStatus = VoucherStatus.active,
  });

  @override
  ConsumerState<MerchantRewardTicketQrInfoPage> createState() =>
      _MerchantRewardTicketQrInfoPageState();
}

class _MerchantRewardTicketQrInfoPageState
    extends ConsumerState<MerchantRewardTicketQrInfoPage> {
  // Markdown content states
  String? _rulesSummaryContent;
  String? _redemptionTermsContent;
  bool _isLoadingRulesSummary = false;
  bool _isLoadingRedemptionTerms = false;
  String? _rulesSummaryError;
  String? _redemptionTermsError;

  // 教學圖文相關狀態
  bool _isUserInstructionExpanded = false;
  String? _userInstructionContent;
  bool _isLoadingUserInstruction = false;
  String? _userInstructionError;

  @override
  void initState() {
    super.initState();
    _loadRulesSummary();
    _loadRedemptionTerms();
    _loadUserInstruction();
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

  Future<void> _loadUserInstruction() async {
    final url = widget.couponRule.userInstructionMdUrl;
    if (url == null || url.isEmpty) return;

    setState(() {
      _isLoadingUserInstruction = true;
      _userInstructionError = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status == 200,
        ),
      );

      if (mounted) {
        setState(() {
          _userInstructionContent = response.data as String;
          _isLoadingUserInstruction = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userInstructionError = '載入教學圖文失敗';
          _isLoadingUserInstruction = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCouponsAsync = switch (widget.initialStatus) {
      VoucherStatus.active => ref.watch(activeCouponsWithRulesProvider),
      VoucherStatus.used => ref.watch(usedCouponsWithRulesProvider),
      VoucherStatus.expired => ref.watch(expiredCouponsWithRulesProvider),
    };

    // 過濾出匹配當前 couponRule 的票券
    final matchingCoupons = activeCouponsAsync.when(
      data: (coupons) => coupons
          .where(
              (item) => item.memberCoupon.couponRuleId == widget.couponRule.id)
          .toList(),
      loading: () => <MemberCouponWithRule>[],
      error: (_, _) => <MemberCouponWithRule>[],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMerchantCard(),
                  const Divider(
                      height: 4, thickness: 4, color: Color(0xFFF0F0F0)),
                  _buildUserInstructionSection(),
                  if (matchingCoupons.isNotEmpty)
                    _buildUsagePeriod(matchingCoupons.first.memberCoupon),
                  _buildExchangeRules(),
                  const Divider(
                      height: 4, thickness: 4, color: Color(0xFFF0F0F0)),
                  _buildExchangeNotes(),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
          // 只有當有匹配票券時才顯示按鈕
          if (matchingCoupons.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomButton(context, matchingCoupons),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
      title: const Text(
        '優惠券',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  /// 商家基本資訊卡片
  Widget _buildMerchantCard() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 上半部有 padding 的區域
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 28, right: 28, bottom: 20),
            child: Row(
              children: [
                // 商家圖示
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.dividerColor,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Builder(
                      builder: (context) {
                        final brandAsync = ref.watch(
                          brandByIdProvider(widget.couponRule.brandId),
                        );
                        return brandAsync.when(
                          data: (brand) {
                            final imageUrl = widget.couponRule.cardImageUrl;
                            if (imageUrl != null && imageUrl.isNotEmpty) {
                              return CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Icon(
                                  ECOCOIcons.ticketFolder,
                                  size: 32,
                                  color: Colors.white,
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(
                                  ECOCOIcons.ticketFolder,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return const Icon(
                              ECOCOIcons.ticketFolder,
                              size: 32,
                              color: Colors.white,
                            );
                          },
                          loading: () => const Icon(
                            ECOCOIcons.ticketFolder,
                            size: 32,
                            color: Colors.white,
                          ),
                          error: (error, stack) => const Icon(
                            ECOCOIcons.ticketFolder,
                            size: 32,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 商家名稱和優惠資訊
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.couponRule.brandName != widget.couponRule.title) Text(
                        widget.couponRule.brandName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryValueColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.couponRule.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
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
                                else if (widget.couponRule.currencyCode ==
                                    CurrencyCode.ntp)
                                  NtpCoinIcon(
                                      isEnabled: true, size: 28, filled: true)
                                else
                                  const Icon(
                                    ECOCOIcons.ecocoSmileOutlined,
                                    size: 28,
                                    color: AppColors.primaryHighlightColor,
                                  ),
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
                                const Icon(
                                  ECOCOIcons.warning,
                                  size: 23,
                                  color: AppColors.primaryHighlightColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    (widget.couponRule.shortNotice == null ||
                                        widget.couponRule.shortNotice!
                                            .trim()
                                            .isEmpty)
                                        ? '使用詳情如下'
                                        : widget.couponRule.shortNotice!,
                                    softWrap: true,
                                    style: const TextStyle(
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

  /// 使用期間
  Widget _buildUsagePeriod(MemberCouponModel memberCoupon) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final startAt = DateTime.parse(memberCoupon.useStartAt);
    final expiredAt = memberCoupon.expiredAt != null
        ? DateTime.parse(memberCoupon.expiredAt!)
        : null;

    final periodText = expiredAt != null
        ? '使用期間：${dateFormat.format(startAt)} ~ ${dateFormat.format(expiredAt)}'
        : '使用期間：${dateFormat.format(startAt)} 起';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 5, left: 28, right: 28, bottom: 0),
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          periodText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryHighlightColor,
          ),
        ),
      ),
    );
  }

  /// 教學圖文區塊（可展開/收合）
  Widget _buildUserInstructionSection() {
    final url = widget.couponRule.userInstructionMdUrl;
    if (url == null || url.isEmpty) return const SizedBox.shrink();

    // 如果讀取完成且沒有內容，則不顯示
    // 只有當「非讀取中」且「有內容」時才顯示，否則一律隱藏
    // (這樣等待期間也會是隱藏的，避免閃爍)
    if (_isLoadingUserInstruction) {
      return const SizedBox.shrink();
    }

    if (_userInstructionError != null ||
        _userInstructionContent == null ||
        _userInstructionContent!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          // 可點擊的標題列
          InkWell(
            onTap: () {
              setState(() {
                _isUserInstructionExpanded = !_isUserInstructionExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isUserInstructionExpanded ? '點擊收合教學圖文' : '點擊展開教學圖文',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    _isUserInstructionExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF0076A9),
                  ),
                ],
              ),
            ),
          ),
          // 展開的內容（使用 AnimatedSize 做動畫）
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _isUserInstructionExpanded
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 28, right: 28, bottom: 12),
                    child: _buildUserInstructionContent(),
                  )
                : const SizedBox.shrink(),
          ),
          const Divider(height: 4, thickness: 4, color: Color(0xFFF0F0F0)),
        ],
      ),
    );
  }

  /// 教學圖文 Markdown 內容
  Widget _buildUserInstructionContent() {
    if (_isLoadingUserInstruction) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      );
    }

    if (_userInstructionError != null) {
      return Text(
        _userInstructionError!,
        style: const TextStyle(color: Colors.red, fontSize: 14),
      );
    }

    if (_userInstructionContent != null && _userInstructionContent!.isNotEmpty) {
      return Markdown(
        data: _userInstructionContent!,
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

    return const SizedBox.shrink();
  }

  /// 兌換說明區
  Widget _buildExchangeRules() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 5, left: 28, right: 28, bottom: 5),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      padding: const EdgeInsets.only(top: 5, left: 28, right: 28, bottom: 5),
      width: double.infinity,
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
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
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
    return const Text(
      '無兌換說明',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  /// 注意事項 Markdown 內容
  Widget _buildRedemptionTermsContent() {
    if (_isLoadingRedemptionTerms) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
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

  Widget _buildBottomButton(
    BuildContext context,
    List<MemberCouponWithRule> matchingCoupons,
  ) {
    final memberCoupon = matchingCoupons.first.memberCoupon;
    final isUsed = memberCoupon.currentStatus == MemberCouponStatus.used;
    final isUnavailable =
        memberCoupon.currentStatus == MemberCouponStatus.unavailable;
    final isDisabled = isUsed || isUnavailable;

    // Determine button text based on status
    String buttonText = '出示條碼';
    final dateFormat = DateFormat('yyyy-MM-dd');

    if (isUsed && memberCoupon.usedAt != null) {
      final usedDate = DateTime.parse(memberCoupon.usedAt!);
      final formattedDate = dateFormat.format(usedDate);

      if (memberCoupon.exchangeUnits != null) {
        if (widget.couponRule.exchangeInputType ==
            ExchangeInputType.amountDiscount) {
          final actionText = widget.couponRule.exchangeFlowType ==
              ExchangeFlowType.directlyUsedDonation ? '捐贈' : '折抵';
          buttonText = '已於 $formattedDate 使用，$actionText ${memberCoupon.exchangeUnits} 元';
        } else if (widget.couponRule.exchangeInputType ==
            ExchangeInputType.pointsConversion) {
          buttonText = '已於 $formattedDate 使用，兌換 ${memberCoupon.exchangeUnits} 點';
        } else {
          buttonText = '已於 $formattedDate 使用';
        }
      } else {
        buttonText = '已於 $formattedDate 使用';
      }
    } else if (isUsed) {
      buttonText = '已使用';
    } else if (isUnavailable) {
      final startDate = DateTime.parse(memberCoupon.useStartAt);
      buttonText = '將於 ${dateFormat.format(startDate)} 開放使用';
    }

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.transparent
        ),
        child: SizedBox(
          height: 38,
          child: ElevatedButton(
            onPressed: isDisabled
                ? null
                : () {
                    final clickedCoupons = matchingCoupons
                        .where((c) => c.memberCoupon.memberCouponId == widget.memberCouponId)
                        .toList();
                    final couponsToPass = clickedCoupons.isNotEmpty 
                        ? clickedCoupons 
                        : matchingCoupons.take(1).toList();
                        
                    context.router.pushThrottledWithTracking(
                      MerchantRewardVerificationCodeQrExchangeRoute(
                        memberCouponsWithRules: couponsToPass,
                        couponRule: widget.couponRule,
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDisabled ? AppColors.disabledButtomBackground : AppColors.primaryHighlightColor,
              disabledBackgroundColor: AppColors.disabledButtomBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
