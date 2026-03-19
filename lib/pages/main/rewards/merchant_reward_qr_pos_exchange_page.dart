import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/ecoco_icons.dart';
import 'package:ecoco_app/pages/common/alerts/verification_code_exchange_success_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../flavors.dart';
import '../../../router/app_router.dart';
import '/models/coupon_rule.dart';
import '/models/voucher_model.dart';
import '/models/coupon_rule_extensions.dart';
import '/models/member_coupon_model.dart';
import '/models/member_coupon_with_rule.dart';
import '/models/prepare_coupon_response.dart';
import '/models/redemption_credential_model.dart';
import '/pages/common/loading_overlay.dart';
import '/providers/brand_provider.dart';
import '/providers/member_coupon_provider.dart';
import '/providers/wallet_provider.dart';
import '/utils/screen_brightness_mixin.dart';
import '/utils/router_analytics_extension.dart';

/// POS Holding 優惠券兌換頁面
/// 顯示待核銷的優惠券資訊與條碼/QR碼供 POS 掃描
@RoutePage()
class MerchantRewardQrPosExchangePage extends ConsumerStatefulWidget {
  final MemberCouponWithRule memberCouponWithRule;
  final PrepareCouponResponse prepareResponse;

  const MerchantRewardQrPosExchangePage({
    super.key,
    required this.memberCouponWithRule,
    required this.prepareResponse,
  });

  @override
  ConsumerState<MerchantRewardQrPosExchangePage> createState() =>
      _MerchantRewardQrPosExchangePageState();
}

class _MerchantRewardQrPosExchangePageState
    extends ConsumerState<MerchantRewardQrPosExchangePage>
    with ScreenBrightnessMixin<MerchantRewardQrPosExchangePage> {
  Timer? _timer;
  late int _remainingSeconds;

  // 門市人員操作指引展開狀態
  final bool _isLoadingStaffInstruction = false;
  bool _isStaffInstructionExpanded = false;
  String? _staffInstructionContent;
  String? _staffInstructionError;
  bool _hasStaffInstruction = false;

  // 取消優惠券狀態
  bool _isCanceling = false;

  // 狀態輪詢計時器
  Timer? _statusPollingTimer;

  // 防止對話框重複顯示
  bool _isDialogShowing = false;

  // 取得倒數時長（秒）- 5分鐘
  int get _expirySeconds => 5 * 60;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _expirySeconds;
    _startTimer();
    _startStatusPolling();
    setBrightnessToMax();
    _checkStaffInstruction();
  }

  @override
  void dispose() {
    restoreOriginalBrightness();
    _timer?.cancel();
    _statusPollingTimer?.cancel();
    super.dispose();
  }

  /// 啟動倒數計時器
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _handleExpired();
      }
    });
  }

  /// 啟動狀態輪詢計時器（每分鐘檢查一次）
  void _startStatusPolling() {
    // 設定每3秒輪詢
    _statusPollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_isDialogShowing && !_isCanceling) {
        _checkCouponStatus();
      }
    });
  }

  /// 檢查優惠券狀態
  Future<void> _checkCouponStatus() async {
    if (_isDialogShowing || _isCanceling) return;

    try {
      final memberCouponId =
          widget.memberCouponWithRule.memberCoupon.memberCouponId;
      final statusResponse = await ref.read(
        getMemberCouponStatusProvider(memberCouponId: memberCouponId).future,
      );

      if (!mounted) return;

      // 解析狀態字串為枚舉
      final status = _parseStatus(statusResponse.currentStatus);

      // 根據狀態處理
      _handleStatusChange(status);
    } catch (e) {
      // 靜默處理錯誤，不影響用戶體驗
      log('Error checking coupon status: $e');
    }
  }

  /// 解析狀態字串為 MemberCouponStatus 枚舉
  MemberCouponStatus _parseStatus(String statusString) {
    switch (statusString.toUpperCase()) {
      case 'UNAVAILABLE':
        return MemberCouponStatus.unavailable;
      case 'ACTIVE':
        return MemberCouponStatus.active;
      case 'USED':
        return MemberCouponStatus.used;
      case 'EXPIRED':
        return MemberCouponStatus.expired;
      case 'REVOKED':
        return MemberCouponStatus.revoked;
      case 'HOLDING':
        return MemberCouponStatus.holding;
      case 'CANCELED':
        return MemberCouponStatus.canceled;
      default:
        return MemberCouponStatus.holding; // 預設為 HOLDING
    }
  }

  /// 根據狀態變化處理
  void _handleStatusChange(MemberCouponStatus status) {
    if (_isDialogShowing || !mounted) return;

    final couponRule = widget.memberCouponWithRule.couponRule;
    final itemId = couponRule?.id ?? '';
    final costPoints = widget.prepareResponse.totalCost;

    switch (status) {
      case MemberCouponStatus.holding:
        // HOLDING 狀態，不做任何處理，繼續等待
        break;

      case MemberCouponStatus.used:
        // 兌換成功
        _stopAllTimers();
        FirebaseAnalytics.instance.logEvent(
          name: 'redeem_success',
          parameters: {'item_id': itemId, 'cost_points': costPoints},
        );
        _showSuccessDialog();
        // Update local DB status immediately to prevent flicker in wallet
        ref.read(
          updateLocalCouponStatusProvider(
            memberCouponId:
                widget.memberCouponWithRule.memberCoupon.memberCouponId,
            status: 'USED',
            usedAt: DateTime.now(),
          ).future,
        );
        break;

      case MemberCouponStatus.unavailable:
        // 未生效/還不可以使用
        _stopAllTimers();
        _logRedeemFail(itemId: itemId, costPoints: costPoints, errorCode: 1);
        _showFailureDialog('結帳失敗', '未生效/還不可以使用');
        // Update local DB status
        ref.read(
          updateLocalCouponStatusProvider(
            memberCouponId:
                widget.memberCouponWithRule.memberCoupon.memberCouponId,
            status: 'UNAVAILABLE',
          ).future,
        );
        break;

      case MemberCouponStatus.revoked:
        // 已註銷退點
        _stopAllTimers();
        _logRedeemFail(itemId: itemId, costPoints: costPoints, errorCode: 2);
        _showFailureDialog('結帳失敗', '已註銷退點');
        // Update local DB status
        ref.read(
          updateLocalCouponStatusProvider(
            memberCouponId:
                widget.memberCouponWithRule.memberCoupon.memberCouponId,
            status: 'REVOKED',
          ).future,
        );
        break;

      case MemberCouponStatus.canceled:
        // 已取消
        _stopAllTimers();
        _logRedeemFail(itemId: itemId, costPoints: costPoints, errorCode: 3);
        _showFailureDialog('結帳失敗', '已取消');
        // Update local DB status
        ref.read(
          updateLocalCouponStatusProvider(
            memberCouponId:
                widget.memberCouponWithRule.memberCoupon.memberCouponId,
            status: 'CANCELED',
          ).future,
        );
        break;

      case MemberCouponStatus.expired:
        // 已過期
        _stopAllTimers();
        _logRedeemFail(itemId: itemId, costPoints: costPoints, errorCode: 4);
        _showFailureDialog('結帳失敗', '優惠券已過期');
        // Update local DB status
        ref.read(
          updateLocalCouponStatusProvider(
            memberCouponId:
                widget.memberCouponWithRule.memberCoupon.memberCouponId,
            status: 'EXPIRED',
          ).future,
        );
        break;

      case MemberCouponStatus.active:
        // ACTIVE 狀態通常不應該在 POS 流程中出現，忽略
        break;
    }
  }

  /// 記錄兌換失敗事件
  void _logRedeemFail({
    required String itemId,
    required int costPoints,
    required int errorCode,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'redeem_fail',
      parameters: {
        'item_id': itemId,
        'cost_points': costPoints,
        'error_code': errorCode,
      },
    );
  }

  /// 停止所有計時器
  void _stopAllTimers() {
    _timer?.cancel();
    _statusPollingTimer?.cancel();
  }

  /// 顯示兌換成功對話框
  void _showSuccessDialog() {
    if (_isDialogShowing || !mounted) return;

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return VerificationCodeExchangeSuccessAlert(
          title: '兌換成功',
          content: '點擊確認跳轉至我的票劵',
          onConfirm: () {
            Navigator.pop(dialogContext);
            // Refresh wallet data to ensure points are up-to-date
            ref.read(walletProvider.notifier).fetchWalletData();
            context.router.popUntilRoot();
            context.router.pushWithTracking(
              VoucherWalletRoute(initialStatus: VoucherStatus.used),
            );
          },
        );
      },
    );
  }

  /// 顯示失敗對話框
  void _showFailureDialog(String title, String content) {
    if (_isDialogShowing || !mounted) return;

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _ErrorAlert(
          title: title,
          content: content,
          onConfirm: () {
            Navigator.pop(dialogContext);
            context.router.popUntilRoot();
          },
        );
      },
    );
  }

  /// 處理逾時
  void _handleExpired() {
    _statusPollingTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _ErrorAlert(
          title: '連線逾時',
          content: '條碼失效，已退回點數\n請重新操作',
          onConfirm: () {
            Navigator.pop(dialogContext);
            context.router.popUntilRoot();
          },
        );
      },
    );
  }

  /// 預先檢查並載入操作指引內容
  Future<void> _checkStaffInstruction() async {
    final couponRule = widget.memberCouponWithRule.couponRule;
    final staffInstructionUrl = couponRule?.staffInstructionMdUrl;

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

  /// 格式化倒數時間為 MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// 處理QR碼被點擊（模擬店家掃描成功）
  void _handleQrCodeTapped() {
    _stopAllTimers();
    _showSuccessDialog();
  }

  /// 處理取消優惠券
  Future<void> _handleCancelCoupon() async {
    if (_isCanceling) return;

    setState(() => _isCanceling = true);
    _timer?.cancel();
    _statusPollingTimer?.cancel();

    try {
      await ref.read(
        cancelCouponProvider(
          memberCouponId:
              widget.memberCouponWithRule.memberCoupon.memberCouponId,
        ).future,
      );

      // Refresh wallet to update points (restore held points)
      await ref.read(walletProvider.notifier).fetchWalletData();
    } catch (e) {
      log('Error canceling coupon: $e');

      // Check current status if cancel failed (might be already used)
      try {
        if (mounted) {
          final memberCouponId =
              widget.memberCouponWithRule.memberCoupon.memberCouponId;
          final statusResponse = await ref.read(
            getMemberCouponStatusProvider(
              memberCouponId: memberCouponId,
            ).future,
          );

          if (mounted) {
            final status = _parseStatus(statusResponse.currentStatus);
            // If terminal status, update local DB immediately
            if (status == MemberCouponStatus.used ||
                status == MemberCouponStatus.expired ||
                status == MemberCouponStatus.revoked ||
                status == MemberCouponStatus.canceled ||
                status == MemberCouponStatus.unavailable) {
              await ref.read(
                updateLocalCouponStatusProvider(
                  memberCouponId: memberCouponId,
                  status: statusResponse.currentStatus,
                  usedAt: status == MemberCouponStatus.used
                      ? DateTime.now()
                      : null,
                ).future,
              );
            }
          }
        }
      } catch (checkError) {
        log('Error checking status after cancel fail: $checkError');
      }
    } finally {
      if (mounted) {
        context.router.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final couponRule = widget.memberCouponWithRule.couponRule;

    if (couponRule == null) {
      return const Scaffold(body: Center(child: Text('無法載入優惠券資訊')));
    }

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
                      // Coupon Paper
                      Expanded(child: _buildCouponPaper(couponRule)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay when canceling
          if (_isCanceling) const LoadingOverlay(),
        ],
      ),
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
            // 標題文字鎖定字體縮放
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
                onPressed: _handleCancelCoupon,
                icon: const Icon(Icons.close, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Coupon Paper 卡片
  Widget _buildCouponPaper(CouponRule couponRule) {
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
                    paperWidth * (34 / 512),
                    paperHeight * (77 / 1152),
                    paperWidth * (34 / 512),
                    paperHeight * (60 / 1152),
                  ),
                  child: _buildPaperContent(couponRule),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Paper 內容
  Widget _buildPaperContent(CouponRule couponRule) {
    final memberCoupon = widget.memberCouponWithRule.memberCoupon;

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

        // 訂單詳情（兌換內容和共計點數）
        _buildOrderDetails(),

        const SizedBox(height: 10),

        // ===== 可捲動中間區域 =====
        const SizedBox(height: 16), // 1. 增加間距

        Expanded(
          // 2. 隱藏 Scrollbar
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
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
                  Builder(
                    builder: (context) {
                      var credentials = memberCoupon.redemptionCredentials;
                      final legacyToken =
                          widget.prepareResponse.legacyPosScanToken;

                      if (legacyToken != null && legacyToken.isNotEmpty) {
                        // 如果有 legacyPosScanToken，替換掉 QR Code 的值
                        credentials = credentials.map((credential) {
                          if (credential.type == CredentialType.qrCode ||
                              credential.type == CredentialType.barcode) {
                            return RedemptionCredentialModel(
                              type: credential.type,
                              title: credential.title,
                              value: legacyToken,
                              showValue: credential.showValue,
                            );
                          }
                          return credential;
                        }).toList();
                      }
                      return _buildRedemptionCredentials(credentials);
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ===== 固定底部區域 =====
        // 倒數計時器, 固定在最下方
        _buildTimer(),

        const SizedBox(height: 12),

        // 取消按鈕
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _handleCancelCoupon,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondaryValueColor,
                side: const BorderSide(color: AppColors.secondaryValueColor, width: 2),
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
        ),

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
                    if (couponRule.brandName != couponRule.title)
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

  /// 訂單詳情（兌換內容和共計點數）
  Widget _buildOrderDetails() {
    final prepareResponse = widget.prepareResponse;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Column(
        children: [
          // 兌換內容
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '兌換內容',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                formatQuantityWithUnit(
                  prepareResponse.exchangedUnits,
                  widget.memberCouponWithRule.couponRule?.displayUnit ?? '',
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
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
                '使用點數',
                style: TextStyle(fontSize: 14, color: Colors.black54),
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
                    '${prepareResponse.totalCost}點',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
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
    if (_isCanceling || credentials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: credentials.map((credential) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
        return GestureDetector(
          onTap: () {
            if (F.appFlavor == Flavor.mock) {
              _handleQrCodeTapped();
            }
          },
          child: Column(
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
          ),
        );

      case CredentialType.textCode:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        );
    }
  }

  /// 倒數計時器
  Widget _buildTimer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      // 3. 倒數計時器鎖定字體縮放
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryValueColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '後將自動失效並退回點數',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryValueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 錯誤提示對話框
class _ErrorAlert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const _ErrorAlert({
    required this.title,
    required this.content,
    required this.onConfirm,
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.formFieldErrorBorder,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5000),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            '確認',
                            style: TextStyle(
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
                              angle: 19.3 * pi / 180,
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
