import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/widgets/daka_coin_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/daka_points_badge.dart';
import '../../../widgets/ntp_coin_icon.dart';
import '../../../widgets/ntp_points_badge.dart';
import '../../common/alerts/simple_error_alert.dart';
import '/models/coupon_rule.dart';
import '/models/voucher_model.dart';
import '/models/coupon_rule_extensions.dart';
import '/models/merchant_reward_card_model.dart';
import '/providers/wallet_provider.dart';
import '/services/online/base_service.dart';
import '/providers/brand_provider.dart';
import '/providers/member_coupon_provider.dart';
import '/ecoco_icons.dart';
import '/pages/common/alerts/reward_confirm_alert.dart';
import '/pages/common/alerts/verification_code_exchange_success_alert.dart';
import '/widgets/ecoco_points_badge.dart';
import '/widgets/circular_checkbox.dart';
import '/router/app_router.dart';
import '/pages/common/loading_overlay.dart';
import '/utils/router_analytics_extension.dart';

/// 商家優惠兌換確認頁面（執行兌換操作）
@RoutePage()
class MerchantRewardExchangeConfirmPage extends ConsumerStatefulWidget {
  final CouponRule couponRule;
  final int userPoints; // 使用者當前點數
  final int? maxExchangeableUnits; // API 回傳的最大可兌換數量

  const MerchantRewardExchangeConfirmPage({
    super.key,
    required this.couponRule,
    this.userPoints = 0,
    this.maxExchangeableUnits,
  });

  @override
  ConsumerState<MerchantRewardExchangeConfirmPage> createState() =>
      _MerchantRewardExchangeConfirmPageState();
}

class _MerchantRewardExchangeConfirmPageState
    extends ConsumerState<MerchantRewardExchangeConfirmPage> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _quantityFocusNode = FocusNode();
  int _exchangeQuantity = 0; // 兌換組數（張數型）
  int _requiredPoints = 0;
  String? _errorMessage;
  bool _agreedToTerms = false; // 同意條款狀態
  bool _isExchanging = false; // 兌換中狀態

  // 兌換說明展開狀態
  bool _isRulesExpanded = false;
  String? _rulesSummaryContent;
  bool _isLoadingRulesSummary = false;
  String? _rulesSummaryError;

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _quantityController.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _amountFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    if (widget.couponRule.rewardExchangeType == RewardExchangeType.amount) {
      _amountController.addListener(_calculatePointsForAmount);
    } else {
      // Initialize quantity to step value (default 1 unit)
      final stepValue = widget.couponRule.exchangeStepValue > 0
          ? widget.couponRule.exchangeStepValue
          : 1;
      _calculatePointsForQuantity(stepValue);
      _quantityController.text = _exchangeQuantity.toString();
    }
    _loadRulesSummary();
    // Auto-focus logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delay to ensure the navigation transition is complete
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        if (widget.couponRule.rewardExchangeType ==
            RewardExchangeType.quantity) {
          _quantityFocusNode.requestFocus();
        } else {
          _amountFocusNode.requestFocus();
        }
      });
    });
  }

  /// 計算所需點數（金額型）
  void _calculatePointsForAmount() {
    final text = _amountController.text;
    if (text.isEmpty) {
      setState(() {
        _requiredPoints = 0;
        _errorMessage = null;
      });
      return;
    }

    final amount = int.tryParse(text) ?? 0;
    final couponRule = widget.couponRule;
    final unitPrice =
        couponRule.unitPrice > 0 ? couponRule.unitPrice : 1;
    final stepValue =
        couponRule.exchangeStepValue > 0 ? couponRule.exchangeStepValue : 1;

    // User Formula for Max Discount
    final walletData = ref.read(walletProvider);
    final currentPoints = walletData?.ecocoWallet.currentBalance ?? widget.userPoints;
    final exchangeCount = currentPoints ~/ unitPrice;
    final maxDiscount = exchangeCount * stepValue;

    // Calculate required points: (amount / step) * unitPrice
    // Note: Since we enforce 'amount % stepValue == 0', integer division is safe here.
    final requiredPoints = (amount ~/ stepValue) * unitPrice;

    // 驗證邏輯
    String? error;

    // 1. 檢查是否為 exchangeStepValue 的倍數
    if (amount % stepValue != 0) {
      error = '請輸入 $stepValue 的倍數';
    }
    // 2. 檢查區間 [stepValue, maxDiscount]
    else if (amount < stepValue) {
      error = '最低兌換金額為 $stepValue';
    } else if (amount > maxDiscount) {
      error = '當前點數不足，請重新輸入';
    }
    // 3. 檢查是否超過 maxPerExchangeCount
    else if (couponRule.maxPerExchangeCount != null &&
        amount > couponRule.maxPerExchangeCount!) {
      error = '超出可折抵限制，請重新輸入';
    }

    setState(() {
      _requiredPoints = requiredPoints;
      _errorMessage = error;
      // Calculate quantity (units) based on amount
      if (amount > 0 && stepValue > 0) {
        _exchangeQuantity = amount ~/ stepValue;
      } else {
        _exchangeQuantity = 0;
      }
    });
  }

  /// 計算所需點數（張數型）
  void _calculatePointsForQuantity(int quantity) {
    setState(() {
      _exchangeQuantity = quantity;
      _requiredPoints = quantity * widget.couponRule.unitPrice;

      // 驗證邏輯
      final walletData = ref.read(walletProvider);
      final currentPoints = walletData?.ecocoWallet.currentBalance ?? widget.userPoints;
      
      if (_requiredPoints > (currentPoints)) {
        _errorMessage = '當前點數不足，請重新輸入';
      } else if (widget.couponRule.maxPerExchangeCount != null &&
          quantity > widget.couponRule.maxPerExchangeCount!) {
        _errorMessage = '超出可兌換限制，請重新輸入';  // ${widget.couponRule.displayUnit}數
      } else {
        _errorMessage = null;
      }
    });
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

  /// 處理確認兌換
  void _handleConfirmExchange() {
    // 關閉鍵盤
    FocusManager.instance.primaryFocus?.unfocus();

    final exchangeFlowType = widget.couponRule.exchangeFlowType;

    // 顯示確認兌換 Alert
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return RewardConfirmAlert(
          exchangeFlowType: exchangeFlowType,
          exchangeAlert: widget.couponRule.exchangeAlert,
          onConfirm: () {
            // 關閉 alert
            Navigator.pop(dialogContext);
            // 執行兌換流程
            _executeExchangeFlow(exchangeFlowType);
          },
          onCancel: () {
            // 單純關閉 alert
            Navigator.pop(dialogContext);
          },
        );
      },
    );
  }

  /// 根據 ExchangeFlowType 執行對應的兌換流程
  Future<void> _executeExchangeFlow(ExchangeFlowType flowType) async {
    switch (flowType) {
      case ExchangeFlowType.directlyAvailableWallet:
        await _handleDirectlyAvailableWallet();
        break;

      case ExchangeFlowType.branchCodeUsed:
      case ExchangeFlowType.branchCodeAvailableWallet:
      case ExchangeFlowType.branchCodeUsedDisplay:
      case ExchangeFlowType.branchCodeAvailableDisplay:
        // 導航到核銷碼輸入頁面
        context.router.pushThrottledWithTracking(
          MerchantRewardVerificationCodeInputRoute(
            couponRule: widget.couponRule,
            userPoints: widget.userPoints,
            exchangeQuantity: _exchangeQuantity,
            requiredPoints: _requiredPoints,
          ),
        );
        break;

      case ExchangeFlowType.posHolding:
        // POS Holding 流程：先呼叫 prepare API，再導航到 QR/POS 頁面
        await _handlePosHolding();
        break;

      case ExchangeFlowType.directlyUsedDonation:
        await _handleDirectlyUsedDonation();
        break;

      case ExchangeFlowType.unknown:
        // 未知類型，返回上一頁
        context.router.pop();
        break;
    }
  }

  /// 處理直接儲存至票券匣的流程
  Future<void> _handleDirectlyAvailableWallet() async {
    if (_isExchanging) return;

    // 關閉鍵盤
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _isExchanging = true);

    try {
      // 計算兌換單位數
      final exchangeUnits = _exchangeQuantity > 0
          ? _exchangeQuantity
          : (_requiredPoints ~/ widget.couponRule.unitPrice);

      await ref.read(
        issueCouponProvider(
          couponRuleId: widget.couponRule.id,
          exchangeUnits: exchangeUnits > 0 ? exchangeUnits : 1,
          branchCode: widget.couponRule.donationCode,
        ).future,
      );

      // Refresh wallet data to update points
      await ref.read(walletProvider.notifier).fetchWalletData();

      // 發送兌換成功事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_success',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': _requiredPoints,
        },
      );

      // 顯示成功 dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => VerificationCodeExchangeSuccessAlert(
            title: '兌換成功',
            content: '點擊確認跳轉至我的票劵',
            onConfirm: () {
              Navigator.pop(dialogContext);
              context.router.popUntilRoot();
              context.router.pushWithTracking(VoucherWalletRoute(initialStatus: VoucherStatus.active));
            },
          ),
        );
      }
    } catch (e) {
      log('Error _handleDirectlyAvailableWallet: $e');

      // 發送兌換失敗事件
      int errorCode = 0;
      if (e is ApiException) {
        errorCode = e.code ?? 0;
      }
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': _requiredPoints,
          'error_code': errorCode,
        },
      );

      // 處理錯誤
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

  /// 處理公益捐贈的流程
  Future<void> _handleDirectlyUsedDonation() async {
    if (_isExchanging) return;

    // 關閉鍵盤
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _isExchanging = true);

    try {
      // 計算兌換單位數
      final exchangeUnits = _exchangeQuantity > 0
          ? _exchangeQuantity
          : (_requiredPoints ~/ widget.couponRule.unitPrice);

      await ref.read(
        issueCouponProvider(
          couponRuleId: widget.couponRule.id,
          exchangeUnits: exchangeUnits > 0 ? exchangeUnits : 1,
          branchCode: widget.couponRule.donationCode,
        ).future,
      );

      // Refresh wallet data to update points
      await ref.read(walletProvider.notifier).fetchWalletData();

      // 發送兌換成功事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_success',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': _requiredPoints,
        },
      );

      // 顯示成功 dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => VerificationCodeExchangeSuccessAlert(
            title: '兌換成功',
            content: '您已完成公益捐贈兌換\n這份心意，將實際幫助需要的人',
            onConfirm: () {
              Navigator.pop(dialogContext);
              // 返回首頁兌換 tab
              context.router.popUntilRoot();
              context.router.pushWithTracking(VoucherWalletRoute(initialStatus: VoucherStatus.used));
            },
          ),
        );
      }
    } catch (e) {
      // 發送兌換失敗事件
      int errorCode = 0;
      if (e is ApiException) {
        errorCode = e.code ?? 0;
      }
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': _requiredPoints,
          'error_code': errorCode,
        },
      );

      // 處理錯誤
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

  /// 處理 POS Holding 的流程
  Future<void> _handlePosHolding() async {
    if (_isExchanging) return;

    // 關閉鍵盤
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _isExchanging = true);

    try {
      // 計算兌換單位數
      final exchangeUnits = _exchangeQuantity > 0
          ? _exchangeQuantity
          : (_requiredPoints ~/ widget.couponRule.unitPrice);

      // 1. 呼叫 prepare API
      log('[DEBUG] Step 1: Calling prepareCoupon...');
      final prepareResponse = await ref.read(
        prepareCouponProvider(
          couponRuleId: widget.couponRule.id,
          exchangeUnits: exchangeUnits > 0 ? exchangeUnits : 1,
        ).future,
      );
      log('[DEBUG] Step 1 done: memberCouponId = ${prepareResponse.memberCouponId}');

      // Refresh wallet data to update points (points are held)
      await ref.read(walletProvider.notifier).fetchWalletData();

      if (!mounted) return;

      // 2. 同步 coupons 資料庫以取得 HOLDING 狀態的 coupon 詳細資料
      log('[DEBUG] Step 2: Calling syncMemberCouponsAction...');
      await ref.read(syncMemberCouponsActionProvider.future);
      log('[DEBUG] Step 2 done: sync completed');

      if (!mounted) return;

      // 3. 取得 memberCoupon 詳細資料
      log('[DEBUG] Step 3: Calling memberCouponsWithRulesById with id: ${prepareResponse.memberCouponId}');
      final memberCouponsWithRules = await ref.read(
        memberCouponsWithRulesByIdProvider([prepareResponse.memberCouponId]).future,
      );
      log('[DEBUG] Step 3 done: got ${memberCouponsWithRules.length} results');

      if (!mounted) return;

      if (memberCouponsWithRules.isEmpty) {
        throw Exception('無法取得優惠券資料');
      }

      // 發送兌換成功事件
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_success',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': _requiredPoints,
        },
      );

      // 4. 導航到 POS 頁面
      if (mounted) {
        context.router.pushThrottledWithTracking(
          MerchantRewardQrPosExchangeRoute(
            memberCouponWithRule: memberCouponsWithRules.first,
            prepareResponse: prepareResponse,
          ),
        );
      }
    } catch (e) {
      log('Error _handlePosHolding: $e');

      // 發送兌換失敗事件
      int errorCode = 0;
      if (e is ApiException) {
        errorCode = e.code ?? 0;
      }
      FirebaseAnalytics.instance.logEvent(
        name: 'redeem_fail',
        parameters: {
          'item_id': widget.couponRule.id,
          'cost_points': _requiredPoints,
          'error_code': errorCode,
        },
      );

      // 處理錯誤
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: _buildAppBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // 商家基本資訊卡片
                  _buildMerchantCard(),

                  const SizedBox(height: 1),

                  // 兌換比例和限制說明
                  _ExchangeRateAndLimitRow(
                    exchangeRate: widget.couponRule.formattedExchangeRate,
                    shortNotice: widget.couponRule.shortNotice,
                    currencyCode: widget.couponRule.currencyCode
                  ),

                  const SizedBox(height: 5),

                  // 點擊展開兌換說明
                  _buildExpandableRulesSection(),

                  const SizedBox(height: 5),
                ],
              ),
            ),

            // 底部兌換操作區（填滿剩餘空間）
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildExchangeActions(),
            ),
          ],
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
      toolbarHeight: 56,
      elevation: 0,
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
            final currentPoints = widget.couponRule.currencyCode ==
                CurrencyCode.ecocoPoint
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

  /// 商家基本資訊卡片
  Widget _buildMerchantCard() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 28, right: 28, bottom: 20),
      decoration: BoxDecoration(
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

  /// 兌換操作區
  Widget _buildExchangeActions() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 16, left: 25, right: 25, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          top: false,
          child: widget.couponRule.rewardExchangeType == RewardExchangeType.quantity
              ? _buildQuantityExchangeControls()
              : _buildAmountExchangeControls(),
        ),
      ),
    );
  }

  /// 金額型兌換控制項
  Widget _buildAmountExchangeControls() {
    // 計算最多可折抵金額
    // final unitPrice =
    //     widget.couponRule.unitPrice > 0 ? widget.couponRule.unitPrice : 1;  // 單位價格(點)
    // final exchangeCount = widget.userPoints ~/ unitPrice; // 最多可兌換數量
    final maxExchangeableUnits = widget.maxExchangeableUnits ?? 0;  // 最多可兌換數量 (widget.userPoints ~/ unitPrice)
    final maxDiscount = maxExchangeableUnits * widget.couponRule.exchangeStepValue;  // 最多可兌換金額

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 標題區塊：點擊按鈕進行兌換
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (widget.couponRule.exchangeInputType ==
                  ExchangeInputType.pointsConversion) ?
              '輸入點數進行兌換' : '點擊按鈕進行兌換',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 當前點數最多可折抵
        Row(
          children: [
            Expanded(
              child: Text(
                (widget.couponRule.exchangeInputType ==
                    ExchangeInputType.pointsConversion)
                    ? '當前最多可兌換'
                    : (widget.couponRule.exchangeInputType ==
                            ExchangeInputType.amountDiscount &&
                        widget.couponRule.exchangeFlowType ==
                            ExchangeFlowType.directlyUsedDonation)
                        ? '當前最多可捐贈'
                        : '當前最多可折抵',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            Text(
              (widget.couponRule.exchangeInputType ==
                  ExchangeInputType.pointsConversion) ?
              '$maxDiscount 點' : '\$$maxDiscount',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 本次兌換金額輸入
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '本次兌換',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryTextColor,
              ),
            ),
            Row(
              children: [
                if (widget.couponRule.exchangeInputType != ExchangeInputType.pointsConversion)
                  const Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                Container(
                  width: 92,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _errorMessage != null
                          ? AppColors.formFieldErrorBorder
                          : (_amountFocusNode.hasFocus
                              ? const Color(0xFF0076A9)
                              : AppColors.secondaryValueColor),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(1.0)),
                    child: TextField(
                      controller: _amountController,
                      focusNode: _amountFocusNode,
                      cursorColor: const Color(0xFF060E9F),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1,
                        fontWeight: FontWeight.w400,
                        color: _errorMessage != null ? AppColors
                            .formFieldErrorBorder : AppColors
                            .secondaryTextColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: (widget.couponRule.exchangeInputType ==
                            ExchangeInputType.pointsConversion)
                            ? '輸入點數'
                            : "輸入金額",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryValueColor,
                        ),
                        isDense: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (_) => _calculatePointsForAmount(),
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ),
                if (widget.couponRule.exchangeInputType == ExchangeInputType.pointsConversion) ...[
                  const SizedBox(width: 8),
                  const Text(
                    '點',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),

        // 錯誤訊息顯示
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.formFieldErrorBorder,
                ),
              ),
            ),
          ),

        const Divider(height: 20, color: Colors.grey),

        // 欲使用點數
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.couponRule.currencyCode != CurrencyCode.ntp)
                  NtpCoinIcon(isEnabled: true, size: 28)
                else
                  Icon(
                    ECOCOIcons.ecocoSmileOutlined,
                    size: 18,
                    color: AppColors.primaryHighlightColor,
                  ),
                SizedBox(width: 6),
                Text(
                  widget.couponRule.currencyCode == CurrencyCode.ntp
                      ? '欲使用'
                      : '欲使用點數',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryHighlightColor,
                  ),
                ),
              ],
            ),
            Text(
              widget.couponRule.currencyCode == CurrencyCode.ntp
                  ? '$_requiredPoints'
                  : '$_requiredPoints 點',
              style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryHighlightColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 確認兌換按鈕
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: _requiredPoints > 0 &&
                    _errorMessage == null
                ? _handleConfirmExchange
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttomBackground,
              disabledBackgroundColor: AppColors.disabledButtomBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              '確認兌換',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 張數型兌換控制項
  Widget _buildQuantityExchangeControls() {
    final int pointsBasedUnits = widget.maxExchangeableUnits ?? 0; // 由點數換算出的可兌換數量
    final int? ruleMaxUnits = widget.couponRule.maxPerExchangeCount; // 每次兌換的數量上限值。若限定一次只能換一張，則此值設為 1（可為 null 表示不限）

    final int exchangeableUnits = (ruleMaxUnits == null)
        ? pointsBasedUnits
        : (pointsBasedUnits < ruleMaxUnits ? pointsBasedUnits : ruleMaxUnits);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 標題：點擊按鈕進行兌換
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '點擊按鈕進行兌換',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 當前點數最多可兌換（灰色文字）
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '當前最多可兌換',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryValueColor,
                fontWeight: FontWeight.w500
              ),
            ),
            Text(
              formatQuantityWithUnit(
                exchangeableUnits,
                widget.couponRule.displayUnit,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryValueColor,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 本次兌換
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '本次兌換',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryTextColor,
              ),
            ),
            Row(
              children: [
                // 減少按鈕
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: _errorMessage != null? AppColors.formFieldErrorBorder : AppColors.indicatorColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _exchangeQuantity > 0
                        ? () {
                            final newQuantity = _exchangeQuantity - widget.couponRule.exchangeStepValue;
                            _calculatePointsForQuantity(newQuantity);
                            _quantityController.text = newQuantity.toString();
                          }
                        : null,
                  ),
                ),
                // 數量顯示（藍色邊框，可編輯）
                Container(
                  width: 60,
                  height: 27,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: _errorMessage != null? AppColors.formFieldErrorBorder : AppColors.indicatorColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                          textScaler: const TextScaler.linear(1.0)),
                      child: TextField(
                        controller: _quantityController,
                        focusNode: _quantityFocusNode,
                        cursorColor: const Color(0xFF060E9F),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w400,
                          color: _errorMessage != null? AppColors.formFieldErrorBorder : AppColors.indicatorColor,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          var quantity = int.tryParse(value) ?? 0;
                          
                          // Limit quantity to exchangeableUnits
                          if (quantity > exchangeableUnits) {
                            quantity = exchangeableUnits;
                            _quantityController.text = quantity.toString();
                            _quantityController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _quantityController.text.length),
                            );
                          }
                          
                          _calculatePointsForQuantity(quantity);
                        },
                      ),
                    ),
                  ),
                ),

                // 增加按鈕
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: _errorMessage != null? AppColors.formFieldErrorBorder : AppColors.indicatorColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _exchangeQuantity < exchangeableUnits
                        ? () {
                            final newQuantity = _exchangeQuantity + widget.couponRule.exchangeStepValue;
                            if (newQuantity <= exchangeableUnits) {
                              _calculatePointsForQuantity(newQuantity);
                              _quantityController.text = newQuantity.toString();
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),

        // 錯誤訊息顯示
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.formFieldErrorBorder,
                ),
              ),
            ),
          ),

        const Divider(height: 30, color: Colors.grey),

        // 欲使用點數
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.couponRule.currencyCode == CurrencyCode.daka)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: DakaCoinIcon(isEnabled: true, size: 18, filled: true,),
                  )
                else if (widget.couponRule.currencyCode == CurrencyCode.ntp)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: NtpCoinIcon(isEnabled: true, size: 18, filled: true,),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(ECOCOIcons.ecocoSmileOutlined, size: 18, color: AppColors.primaryHighlightColor),
                  ),
                SizedBox(width: 6),
                Text(
                  widget.couponRule.currencyCode == CurrencyCode.ntp
                      ? '欲使用'
                      : '欲使用點數',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryHighlightColor,
                  ),
                ),
              ],
            ),
            Text(
              widget.couponRule.currencyCode == CurrencyCode.ntp
                  ? '$_requiredPoints'
                  : '$_requiredPoints 點',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: widget.couponRule.currencyCode == CurrencyCode.ntp
                    ? AppColors.ntpCoinColor
                    : AppColors.primaryHighlightColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 我同意電子折抵券一經兌換，不退還點數。
        Row(
          children: [
            CircularCheckbox(
              value: _agreedToTerms,
              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value;
                });
              },
              //activeColor: Colors.black,
              //inactiveColor: Colors.black
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '我同意電子折抵券一經兌換，不退還點數。',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 確認兌換按鈕
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: _exchangeQuantity > 0 &&
                    _errorMessage == null &&
                    _agreedToTerms
                ? _handleConfirmExchange
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttomBackground,
              disabledBackgroundColor: AppColors.disabledButtomBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              '確認兌換',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
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
}

/// 兌換比例和限制說明行
class _ExchangeRateAndLimitRow extends StatelessWidget {
  final String exchangeRate;
  final String? shortNotice;
  final CurrencyCode? currencyCode;

  const _ExchangeRateAndLimitRow({
    required this.exchangeRate,
    this.shortNotice,
    this.currencyCode
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
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
                        if (currencyCode == CurrencyCode.daka)
                          DakaCoinIcon(isEnabled: true, size: 28)
                        else if (currencyCode == CurrencyCode.ntp)
                          NtpCoinIcon(isEnabled: true, size: 28)
                        else
                          Icon(ECOCOIcons.ecocoSmileOutlined, size: 28, color: AppColors.primaryHighlightColor),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            exchangeRate,
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
            const SizedBox(width: 30),

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
                            (shortNotice == null || shortNotice!.trim().isEmpty)
                                ? '使用詳情如下'
                                : shortNotice!,
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
        ));
  }
}
