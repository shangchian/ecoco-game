import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/merchant_reward_card_model.dart';
import '../../common/alerts/simple_error_alert.dart';
import '/ecoco_icons.dart';
import '/models/coupon_rule.dart';
import '/models/voucher_model.dart';
import '/models/coupon_rule_extensions.dart';
import '/providers/auth_provider.dart';
import '/providers/brand_provider.dart';
import '/providers/member_coupon_provider.dart';
import '/pages/common/alerts/verification_code_exchange_success_alert.dart';
import '/pages/common/loading_overlay.dart';
import '/services/online/base_service.dart';
import '/widgets/ecoco_points_badge.dart';
import '/providers/wallet_provider.dart';
import '/router/app_router.dart';
import '/utils/router_analytics_extension.dart';

/// 商家優惠核銷碼輸入頁面（使用作業系統鍵盤）
@RoutePage()
class MerchantRewardVerificationCodeInputPage extends ConsumerStatefulWidget {
  final CouponRule couponRule;
  final int userPoints;
  final int exchangeQuantity; // 兌換數量（組數）
  final int requiredPoints; // 所需點數

  const MerchantRewardVerificationCodeInputPage({
    super.key,
    required this.couponRule,
    this.userPoints = 0,
    this.exchangeQuantity = 0,
    this.requiredPoints = 0,
  });

  @override
  ConsumerState<MerchantRewardVerificationCodeInputPage> createState() =>
      _MerchantRewardVerificationCodeInputPageState();
}

class _MerchantRewardVerificationCodeInputPageState
    extends ConsumerState<MerchantRewardVerificationCodeInputPage> {
  final TextEditingController _verificationCodeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;
  bool _isExchanging = false;

  // 兌換說明展開狀態
  bool _isRulesExpanded = false;
  String? _rulesSummaryContent;
  bool _isLoadingRulesSummary = false;
  String? _rulesSummaryError;

  // 門市人員操作指引展開狀態
  bool _isStaffInstructionExpanded = false;
  String? _staffInstructionContent;
  bool _isLoadingStaffInstruction = false;
  String? _staffInstructionError;

  @override
  void initState() {
    super.initState();
    // 頁面載入後自動聚焦到輸入框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    // 載入兌換說明和門市人員操作指引
    _loadRulesSummary();
    _loadStaffInstruction();
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 載入兌換說明 Markdown 內容
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

  /// 載入門市人員操作指引 Markdown 內容
  Future<void> _loadStaffInstruction() async {
    final staffInstructionUrl = widget.couponRule.staffInstructionMdUrl;
    if (staffInstructionUrl == null || staffInstructionUrl.isEmpty) return;

    setState(() {
      _isLoadingStaffInstruction = true;
      _staffInstructionError = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        staffInstructionUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status == 200,
        ),
      );

      if (mounted) {
        setState(() {
          _staffInstructionContent = response.data as String;
          _isLoadingStaffInstruction = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _staffInstructionError = '載入操作指引失敗';
          _isLoadingStaffInstruction = false;
        });
      }
    }
  }

  /// 處理確認兌換
  Future<void> _handleConfirmExchange() async {
    if (_isExchanging) return;

    final verificationCode = _verificationCodeController.text;
    if (verificationCode.isEmpty) return;

    // 關閉鍵盤
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _isExchanging = true);

    try {
      final exchangeUnits = widget.exchangeQuantity > 0
          ? widget.exchangeQuantity
          : (widget.requiredPoints ~/ widget.couponRule.unitPrice);

      // 1. 呼叫 issueCoupon API
      final response = await ref.read(
        issueCouponProvider(
          couponRuleId: widget.couponRule.id,
          exchangeUnits: exchangeUnits > 0 ? exchangeUnits : 1,
          branchCode: verificationCode,
        ).future,
      );

      // 兌換成功：發送 redeem_success 事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_success',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': widget.requiredPoints,
        },
      );

      if (mounted) {
        if (widget.couponRule.exchangeFlowType == ExchangeFlowType.branchCodeUsed) {
          // 純核銷碼類型：顯示兌換成功 Alert 後返回我的票劵
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => VerificationCodeExchangeSuccessAlert(
              title: '兌換成功',
              content: '點擊確認跳轉至我的票劵',
              onConfirm: () {
                Navigator.pop(dialogContext);
                ref.read(walletProvider.notifier).fetchWalletData();
                context.router.popUntilRoot();
                context.router.pushWithTracking(VoucherWalletRoute(initialStatus: VoucherStatus.used));
              },
            ),
          );
        } else if (widget.couponRule.exchangeFlowType == ExchangeFlowType.branchCodeAvailableWallet) {
          // 輸入核銷碼後，儲存至票券匣可使用區 (v2.0 未實作, 先部署該功能)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => VerificationCodeExchangeSuccessAlert(
              title: '兌換成功',
              content: '點擊確認跳轉至我的票劵',
              onConfirm: () {
                Navigator.pop(dialogContext);
                ref.read(walletProvider.notifier).fetchWalletData();
                context.router.popUntilRoot();
                context.router.pushWithTracking(VoucherWalletRoute(initialStatus: VoucherStatus.active));
              },
            ),
          );
        } else if (widget.couponRule.exchangeFlowType == ExchangeFlowType.branchCodeUsedDisplay || widget.couponRule.exchangeFlowType == ExchangeFlowType.branchCodeAvailableDisplay) {
          // 2. 同步資料庫取得新發行的 coupons
          await ref.read(syncMemberCouponsActionProvider.future);

          // 3. 查詢剛發行的 coupons 詳細資料
          final memberCouponsWithRules = await ref.read(
            memberCouponsWithRulesByIdProvider(response.issuedMemberCouponIds).future,
          );

          // 4. 導航到顯示頁面（帶入實際 coupon 資料）
          if (mounted) {
            context.router.pushThrottledWithTracking(
              MerchantRewardVerificationCodeQrExchangeRoute(
                memberCouponsWithRules: memberCouponsWithRules,
                couponRule: widget.couponRule,
              ),
            );
          }
        }
      }
    } on NotAuthenticatedException {
      // 兌換失敗：發送 redeem_fail 事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': widget.requiredPoints,
          'error_code': 401,
        },
      );
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '兌換失敗',
            message: '請先登入',
            buttonText: '確認',
            onPressed: () {},
          ),
        );
      }
    } on TokenRefreshFailedException {
      // 兌換失敗：發送 redeem_fail 事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': widget.requiredPoints,
          'error_code': 401,
        },
      );
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '身份驗證失敗',
            message: '登入狀態已過期，請重新登入以繼續使用',
            buttonText: '確認',
            onPressed: () {},
          ),
        );
      }
    } on ApiException catch (e) {
      // 兌換失敗：發送 redeem_fail 事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': widget.requiredPoints,
          'error_code': e.code ?? 0,
        },
      );
      if (e.code == 30019) {
        // 核銷碼錯誤
        if (mounted) {
          _showVerificationErrorDialog(
            title: '兌換失敗',
            message: '核銷碼錯誤\n請重新輸入',
            buttonText: '重新輸入',
          );
        }
      } else {
        // 其他 API 錯誤：顯示 API 回傳的訊息
        if (mounted) {
          await showDialog(
            context: context,
            builder: (_) => SimpleErrorAlert(
              title: '兌換失敗',
              message: e.message,
              buttonText: '確認',
              onPressed: () {},
            ),
          );
        }
      }
    } catch (e) {
      // 兌換失敗：發送 redeem_fail 事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': widget.requiredPoints,
          'error_code': 0,
        },
      );
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            title: '兌換失敗',
            message: e.toString(),
            buttonText: '確認',
            onPressed: () {},
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExchanging = false);
    }
  }

  /// 顯示核銷碼錯誤 Dialog
  void _showVerificationErrorDialog({
    String title = '兌換失敗',
    String message = '核銷碼錯誤\n請重新輸入',
    String buttonText = '重新輸入',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _VerificationErrorAlert(
        onRetry: () {
          Navigator.pop(dialogContext);
          // 聚焦回輸入框
          _focusNode.requestFocus();
        },
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          appBar: _buildAppBar(),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 商家基本資訊卡片
                    _buildMerchantCard(),

                    Container(height: 1, color: const Color(0xFFF2F2F2)),

                    // 訂單內容詳情
                    _buildOrderDetailsSection(),

                    Container(height: 5, color: const Color(0xFFF2F2F2)),

                    // 點擊展開兌換說明
                    _buildExpandableRulesSection(),

                    Container(height: 5, color: const Color(0xFFF2F2F2)),

                    // 底部核銷碼輸入區
                    _buildVerificationCodeInputArea(),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isExchanging) const LoadingOverlay(),
      ],
    );
  }

  /// 頂部 AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundYellow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 56,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => context.router.maybePop(),
      ),
      title: const Text(
        '兌換優惠',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
      actions: [
        // 使用者點數顯示
        EcocoPointsBadge.detailed(
          points: widget.userPoints,
        ),
      ],
    );
  }

  /// 商家基本資訊卡片
  Widget _buildMerchantCard() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 28, right: 28, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
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
                              errorWidget: (context, url, error) => const Icon(
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
        ],
      ),
    );
  }

  /// 訂單內容詳情區塊
  Widget _buildOrderDetailsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 兌換內容
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '兌換內容',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryValueColor,
                ),
              ),
              Text(
                formatQuantityWithUnit(
                  widget.couponRule.rewardExchangeType ==
                          RewardExchangeType.amount
                      ? widget.exchangeQuantity *
                          (widget.couponRule.exchangeStepValue > 0
                              ? widget.couponRule.exchangeStepValue
                              : 1)
                      : widget.exchangeQuantity,
                  widget.couponRule.displayUnit,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 共計點數
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '共計',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryValueColor,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    ECOCOIcons.ecocoSmileOutlined,
                    size: 18,
                    color: AppColors.primaryHighlightColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.requiredPoints}點',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 可展開的兌換說明區塊
  Widget _buildExpandableRulesSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 標題列（點擊展開/收合）
          InkWell(
            onTap: () {
              setState(() {
                _isRulesExpanded = !_isRulesExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // 左邊佔位，與右邊 Icon 寬度相同，讓文字視覺置中
                  const SizedBox(width: 30),
                  Expanded(
                    child: Center(
                      child: Text(
                        _isRulesExpanded ? '點擊收合兌換說明' : '點擊展開兌換說明',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    _isRulesExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.indicatorColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),

          // 展開的內容區
          if (_isRulesExpanded) _buildRulesSummaryContent(),
        ],
      ),
    );
  }

  /// 兌換說明 Markdown 內容
  Widget _buildRulesSummaryContent() {
    if (_isLoadingRulesSummary) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      );
    }

    if (_rulesSummaryError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          _rulesSummaryError!,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }

    if (_rulesSummaryContent != null && _rulesSummaryContent!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Markdown(
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
        ),
      );
    }

    // Fallback - 顯示無兌換說明
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        '無兌換說明',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }

  /// 紅色警示區塊
  Widget _buildWarningSection() {
    if (widget.couponRule.shortNotice == null ||
        widget.couponRule.shortNotice!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 335,
      height: 40,
      decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: AppColors.formFieldErrorBorder,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.couponRule.shortNotice!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.formFieldErrorBorder,
            ),
          ),
        ],
      ),
    );
  }

  /// 門市人員操作指引區塊
  Widget _buildStaffInstructionSection() {
    // 如果沒有 staffInstructionMdUrl，不顯示此區塊
    /*if (widget.couponRule.staffInstructionMdUrl == null ||
        widget.couponRule.staffInstructionMdUrl!.isEmpty) {
      return const SizedBox.shrink();
    }*/

    // 如果正在載入或內容為空，不顯示此區塊
    if (_isLoadingStaffInstruction ||
        _staffInstructionContent == null ||
        _staffInstructionContent!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 335,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // 標題列（點擊展開/收合）
          InkWell(
            onTap: () {
              setState(() {
                _isStaffInstructionExpanded = !_isStaffInstructionExpanded;
              });
            },
            child: Row(
                children: [
                  // 左邊佔位，與右邊 Icon 寬度相同，讓文字視覺置中
                  const SizedBox(width: 50),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '門市人員操作指引',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    _isStaffInstructionExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.indicatorColor,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                ],
            ),
          ),
        ],
      ),
    );
  }

  /// 門市人員操作指引 Markdown 內容
  Widget _buildStaffInstructionContent() {
    Widget content;

    if (_isLoadingStaffInstruction) {
      content = const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      );
    } else if (_staffInstructionError != null) {
      content = Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          _staffInstructionError!,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    } else if (_staffInstructionContent != null && _staffInstructionContent!.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Markdown(
          data: _staffInstructionContent!,
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
        ),
      );
    } else {
      // Fallback - 顯示無操作指引
      content = const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '無操作指引',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.secondaryTextColor,
            fontWeight: FontWeight.w500
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 335,
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }

  /// 核銷碼輸入區
  Widget _buildVerificationCodeInputArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 標題區塊：輸入核銷碼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '輸入核銷碼',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          if (widget.couponRule.shortNotice != null &&
              widget.couponRule.shortNotice!.trim().isNotEmpty)
            const SizedBox(height: 16),

          // 紅色警示
          _buildWarningSection(),

          // 門市人員操作指引
          _buildStaffInstructionSection(),

          if (_isStaffInstructionExpanded) _buildStaffInstructionContent(),

          const SizedBox(height: 16),

          // 核銷碼輸入框 + 確認按鈕
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 輸入框
              Container(
                height: 40,
                width: 260,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _errorMessage != null
                        ? AppColors.formFieldErrorBorder
                        : _verificationCodeController.text.isEmpty
                            ? AppColors.disabledButtomBackground
                            : AppColors.indicatorColor,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: TextField(
                  controller: _verificationCodeController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _errorMessage != null
                        ? AppColors.formFieldErrorBorder
                        : _verificationCodeController.text.isEmpty
                            ? AppColors.disabledButtomBackground
                            : AppColors.indicatorColor,
                    letterSpacing: 4,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '請輸入核銷碼',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryValueColor,
                      letterSpacing: 0,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      // 清除錯誤訊息
                      if (_errorMessage != null) {
                        _errorMessage = null;
                      }
                    });
                  },
                ),
              ),
              // 確認按鈕
              ElevatedButton(
                onPressed: _verificationCodeController.text.isNotEmpty ? _handleConfirmExchange : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _errorMessage != null
                      ? AppColors.formFieldErrorBorder
                      : _verificationCodeController.text.isEmpty
                          ? AppColors.disabledButtomBackground
                          : AppColors.indicatorColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  minimumSize: const Size(73, 40),
                ),
                child: const Text(
                  '確認',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // 錯誤訊息
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF5000),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 核銷碼錯誤 Alert（單一按鈕）
class _VerificationErrorAlert extends StatelessWidget {
  final VoidCallback onRetry;
  final String title;
  final String message;
  final String buttonText;

  const _VerificationErrorAlert({
    required this.onRetry,
    this.title = '兌換失敗',
    this.message = '核銷碼錯誤\n請重新輸入',
    this.buttonText = '重新輸入',
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 半透明背景
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),

          // Alert 視窗
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.fromLTRB(20, 96, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.warningRed,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      // 重新輸入按鈕
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onRetry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5000),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Pac-Man 風格圖示組合
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 210,
                      height: 146,
                      child: Stack(
                        children: [
                          // 左側 Pac-Man (ecoco_smile.png)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Image.asset(
                              'assets/images/ecoco_smile.png',
                              width: 136,
                              height: 136,
                            ),
                          ),
                          // 右側驚嘆號 (ecoco_alert.png) - 旋轉 19.3 度
                          Positioned(
                            right: 0,
                            top: 40,
                            child: Transform.rotate(
                              angle: 19.3 * pi / 180, // 轉換為弧度
                              child: Image.asset(
                                'assets/images/ecoco_alert.png',
                                width: 63,
                                height: 63,
                              ),
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
        ],
      ),
    );
  }
}
