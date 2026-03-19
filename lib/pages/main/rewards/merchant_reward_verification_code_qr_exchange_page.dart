import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ecoco_icons.dart';
import '/models/coupon_rule.dart';
import '/models/member_coupon_model.dart';
import '/models/member_coupon_with_rule.dart';
import '/models/redemption_credential_model.dart';
import '/pages/common/loading_overlay.dart';
import '/providers/brand_provider.dart';
import '/providers/member_coupon_provider.dart';
import '/pages/common/alerts/verification_code_exchange_success_alert.dart';
import '/pages/common/alerts/verification_code_scan_confirm_alert.dart';
import '/models/voucher_model.dart';
import '/providers/wallet_provider.dart';
import '/router/app_router.dart';
import '/utils/screen_brightness_mixin.dart';
import '/utils/router_analytics_extension.dart';

/// 核銷碼兌換後顯示QR碼/條碼頁面（支援多張 coupon 左右滑動）
@RoutePage()
class MerchantRewardVerificationCodeQrExchangePage
    extends ConsumerStatefulWidget {
  final List<MemberCouponWithRule> memberCouponsWithRules;
  final CouponRule couponRule;

  const MerchantRewardVerificationCodeQrExchangePage({
    super.key,
    required this.memberCouponsWithRules,
    required this.couponRule,
  });

  @override
  ConsumerState<MerchantRewardVerificationCodeQrExchangePage> createState() =>
      _MerchantRewardVerificationCodeQrExchangePageState();
}

class _MerchantRewardVerificationCodeQrExchangePageState
    extends ConsumerState<MerchantRewardVerificationCodeQrExchangePage>
    with ScreenBrightnessMixin<MerchantRewardVerificationCodeQrExchangePage> {
  late PageController _pageController;
  int _currentPage = 0;

  // 門市人員操作指引展開狀態
  final bool _isLoadingStaffInstruction = false;
  bool _isStaffInstructionExpanded = false;
  String? _staffInstructionContent;
  String? _staffInstructionError;
  bool _hasStaffInstruction = false;

  // 確認使用中狀態
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    setBrightnessToMax();
    _logUseCouponShowEvent();
    _checkStaffInstruction();

    // Refresh wallet info on page initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).fetchWalletData();
    });
  }

  /// 發送 use_coupon_show 事件
  void _logUseCouponShowEvent() {
    FirebaseAnalytics.instance.logEvent(
      name: 'use_coupon_show',
      parameters: {'coupon_id': widget.couponRule.id},
    );
  }

  @override
  void dispose() {
    restoreOriginalBrightness();
    _pageController.dispose();
    super.dispose();
  }

  /// 取得當前顯示的 coupon
  MemberCouponWithRule get _currentCoupon =>
      widget.memberCouponsWithRules[_currentPage];

  /// 預先檢查並載入操作指引內容
  Future<void> _checkStaffInstruction() async {
    final couponRule = _currentCoupon.couponRule ?? widget.couponRule;
    final staffInstructionUrl = couponRule.staffInstructionMdUrl;

    // 如果 URL 為空，直接返回（_hasStaffInstruction 預設為 false）
    if (staffInstructionUrl == null || staffInstructionUrl.isEmpty) return;

    try {
      final dio = Dio();
      final response = await dio.get(
        staffInstructionUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status == 200,
        ),
      );

      final content = response.data as String;

      // 檢查內容是否為空
      if (mounted && content.trim().isNotEmpty) {
        setState(() {
          _staffInstructionContent = content;
          _hasStaffInstruction = true;
        });
      }
    } catch (e) {
      log('Check staff instruction failed: $e');
      // 失敗時保持隱藏
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            body: Stack(
              children: [
                // 全螢幕黃色背景
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/coupon_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // 主要內容
                Positioned.fill(
                  child: Column(
                    children: [
                      // Coupon PageView
                      Expanded(child: _buildCouponPageView()),

                      // 頁面指示器
                      if (widget.memberCouponsWithRules.length > 1)
                        _buildPageIndicator(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay when confirming
          if (_isConfirming) const LoadingOverlay(),
        ],
      ),
    );
  }

  /// Coupon PageView
  Widget _buildCouponPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.memberCouponsWithRules.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
          // 切換頁面時重置操作指引狀態
          _isStaffInstructionExpanded = false;
          _staffInstructionContent = null;
          _staffInstructionError = null;
          _hasStaffInstruction = false;
          _checkStaffInstruction();
        });
      },
      itemBuilder: (context, index) {
        return _buildCouponPaper(widget.memberCouponsWithRules[index]);
      },
    );
  }

  /// 頂部區域：標題和關閉按鈕
  Widget _buildTopBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.textCursorColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 40), // 左側佔位
            Expanded(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '請刷條碼進行兌換',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // 關閉按鈕（隱藏但維持佔位）
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                onPressed: () {
                  if (widget.couponRule.exchangeFlowType ==
                      ExchangeFlowType.branchCodeUsedDisplay) {
                    // 票劵已使用，直接導向我的票劵的已使用分頁
                    context.router.popUntilRoot();
                    context.router.pushWithTracking(
                      VoucherWalletRoute(initialStatus: VoucherStatus.used),
                    );
                  } else {
                    // 其他情況直接回退上一頁
                    context.router.pop();
                  }
                },
                icon: const Icon(Icons.close, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Coupon Paper 卡片
  Widget _buildCouponPaper(MemberCouponWithRule couponWithRule) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paperWidth = screenWidth;
    final paperHeight = paperWidth * (1152 / 512); // 維持原始比例

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Center(
        child: SizedBox(
          width: paperWidth,
          height: paperHeight,
          child: Stack(
            children: [
              // Paper 背景圖
              Positioned.fill(
                child: Image.asset(
                  'assets/images/coupon_paper.png',
                  fit: BoxFit.fill,
                ),
              ),

              // 內容 overlay
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(
                    paperWidth * (33 / 512),
                    paperHeight * (76 / 1152),
                    paperWidth * (33 / 512),
                    paperHeight * (60 / 1152),
                  ),
                  child: _buildPaperContent(couponWithRule),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Paper 內容
  Widget _buildPaperContent(MemberCouponWithRule couponWithRule) {
    final memberCoupon = couponWithRule.memberCoupon;
    final couponRule = couponWithRule.couponRule ?? widget.couponRule;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ===== 固定頂部區域 =====
        // 頂部區域：標題和關閉按鈕
        _buildTopBar(),

        const SizedBox(height: 8),

        // 品牌 logo 和名稱
        _buildBrandInfo(couponRule),

        // 使用期間
        _buildUsagePeriod(memberCoupon),

        const SizedBox(height: 10),

        // ===== 可捲動中間區域 =====
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 警示訊息
                _buildWarningBadge(couponRule),

                const SizedBox(height: 8),

                // 門市人員操作指引（可展開）
                if (_hasStaffInstruction) ...[
                  _buildStaffInstructionSection(),

                  // 展開時顯示操作指引內容
                  if (_isStaffInstructionExpanded) ...[
                    const SizedBox(height: 8),
                    _buildStaffInstructionContent(),
                  ],
                ],

                const SizedBox(height: 16),

                // 兌換憑證（條碼/QR碼）
                _buildRedemptionCredentials(memberCoupon.redemptionCredentials),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ===== 固定底部區域 =====
        // 確認使用按鈕
        _buildConfirmButton(),

        const SizedBox(height: 24),
      ],
    );
  }

  /// 品牌資訊
  Widget _buildBrandInfo(CouponRule couponRule) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 28, right: 28, bottom: 20),
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
                  border: Border.all(color: AppColors.dividerColor, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Builder(
                    builder: (context) {
                      final brandAsync = ref.watch(
                        brandByIdProvider(couponRule.brandId),
                      );
                      return brandAsync.when(
                        data: (brand) {
                          final imageUrl = couponRule.cardImageUrl;
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
                    if (widget.couponRule.brandName != widget.couponRule.title)
                      Text(
                        couponRule.brandName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryValueColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      couponRule.title,
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
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          periodText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.formFieldErrorBorder,
          ),
        ),
      ),
    );
  }

  /// 警示訊息
  Widget _buildWarningBadge(CouponRule couponRule) {
    // If shortNotice is null or empty, hide the widget
    if (couponRule.shortNotice == null || couponRule.shortNotice!.isEmpty) {
      return const SizedBox.shrink();
    }
    final warningText = couponRule.shortNotice!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
          Flexible(
            child: Text(
              warningText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.formFieldErrorBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 門市人員操作指引區塊
  Widget _buildStaffInstructionSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isStaffInstructionExpanded = !_isStaffInstructionExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              '門市人員操作指引',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryTextColor,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                _isStaffInstructionExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.indicatorColor,
                size: 25,
              ),
            ),
          ],
        ),
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
    } else if (_staffInstructionContent != null &&
        _staffInstructionContent!.isNotEmpty) {
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
                await launchUrl(uri, mode: LaunchMode.externalApplication);
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
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }

  /// 兌換憑證（條碼/QR碼）
  Widget _buildRedemptionCredentials(
    List<RedemptionCredentialModel> credentials,
  ) {
    if (_isConfirming || credentials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: credentials.map((credential) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildCredentialWidget(credential),
        );
      }).toList(),
    );
  }

  /// 單一憑證 Widget
  Widget _buildCredentialWidget(RedemptionCredentialModel credential) {
    final value = credential.value ?? '';

    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    switch (credential.type) {
      case CredentialType.barcode:
        return Column(
          children: [
            BarcodeWidget(
              barcode: Barcode.code128(),
              data: value,
              width: 240,
              height: 50,
              drawText: false,
            ),
            if (credential.showValue)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        );

      case CredentialType.qrCode:
        return Column(
          children: [
            QrImageView(
              data: value,
              version: QrVersions.auto,
              size: 150,
              backgroundColor: Colors.white,
            ),
            if (credential.showValue)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        );

      case CredentialType.textCode:
        return Column(
          children: [
            if (credential.title != null && credential.title!.isNotEmpty) ...[
              Text(
                credential.title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade300),
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
          ],
        );
    }
  }

  /// 頁面指示器
  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.memberCouponsWithRules.length,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentPage
                  ? AppColors.primaryHighlightColor
                  : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  /// 確認使用按鈕區塊
  Widget _buildConfirmButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Text(
            '經由門市人員操作確認，按下後無法取消',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: _handleConfirmUse,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
              ),
              child: const Text(
                '確認使用',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 取消按鈕
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                if (widget.couponRule.exchangeFlowType ==
                    ExchangeFlowType.branchCodeUsedDisplay) {
                  context.router.popUntilRoot();
                  context.router.pushWithTracking(
                    VoucherWalletRoute(initialStatus: VoucherStatus.used),
                  );
                } else {
                  context.router.pop();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondaryValueColor,
                side: const BorderSide(
                  color: AppColors.secondaryValueColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text(
                '取消',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 處理確認使用按鈕點擊（只確認當前顯示的 coupon）
  void _handleConfirmUse() {
    final currentCoupon = _currentCoupon;
    final couponRule = currentCoupon.couponRule ?? widget.couponRule;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VerificationCodeScanConfirmAlert(
          type: CredentialType.qrCode,
          onConfirm: () async {
            // 根據不同 flow type 決定是否略過 finalize
            if (couponRule.exchangeFlowType ==
                ExchangeFlowType.branchCodeUsedDisplay) {
              if (mounted) {
                // Log redeem success event
                FirebaseAnalytics.instance.logEvent(
                  name: 'use_coupon_success',
                  parameters: {'coupon_id': couponRule.id},
                );

                _showSuccessDialog(
                  onConfirm: (successDialogContext) {
                    Navigator.pop(successDialogContext);
                    context.router.popUntilRoot();
                    context.router.pushWithTracking(
                      VoucherWalletRoute(initialStatus: VoucherStatus.used),
                    );
                  },
                );
              }
              return;
            }

            setState(() => _isConfirming = true);

            try {
              // 呼叫 finalize API: 手動點擊使用優惠券
              await ref.read(
                finalizeCouponProvider(
                  memberCouponId: currentCoupon.memberCoupon.memberCouponId,
                ).future,
              );

              if (mounted) {
                setState(() => _isConfirming = false);

                // Log redeem success event
                FirebaseAnalytics.instance.logEvent(
                  name: 'use_coupon_success',
                  parameters: {'coupon_id': couponRule.id},
                );

                if (couponRule.exchangeFlowType ==
                    ExchangeFlowType.directlyAvailableWallet) {
                  _showSuccessDialog(
                    onConfirm: (successDialogContext) {
                      Navigator.pop(successDialogContext);
                      context.router.popUntilRoot();
                      context.router.pushWithTracking(
                        VoucherWalletRoute(initialStatus: VoucherStatus.used),
                      );
                    },
                  );
                } else {
                  _showSuccessDialog();
                }
              }
            } catch (e) {
              log('Error finalizing coupon: $e');
              if (mounted) {
                setState(() => _isConfirming = false);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('使用失敗: $e')));
              }
            }
          },
          onCancel: () {},
        );
      },
    );
  }

  /// 顯示成功 Dialog
  void _showSuccessDialog({void Function(BuildContext)? onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VerificationCodeExchangeSuccessAlert(
          title: '兌換成功',
          content: '點擊確認跳轉至我的票劵',
          onConfirm: () {
            if (onConfirm != null) {
              onConfirm(dialogContext);
            } else {
              Navigator.pop(dialogContext);
              context.router.popUntilRoot();
            }
          },
        );
      },
    );
  }
}
