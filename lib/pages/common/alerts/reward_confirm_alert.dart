import 'dart:math';
import 'package:ecoco_app/constants/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '/models/coupon_rule.dart';

class RewardConfirmAlert extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final ExchangeFlowType exchangeFlowType;
  final String? exchangeAlert;

  const RewardConfirmAlert({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.exchangeFlowType,
    this.exchangeAlert,
  });

  /// 根據兌換流程類型返回對應的警告訊息
  String _getWarningMessage() {
    switch (exchangeFlowType) {
      case ExchangeFlowType.directlyAvailableWallet:
        // 直接儲存至票券匣
        return exchangeAlert != null && exchangeAlert!.isNotEmpty
            ? '$exchangeAlert' : '確認後將存入我的票券，一經兌換恕不退還點數';

      case ExchangeFlowType.branchCodeUsed:
      case ExchangeFlowType.branchCodeUsedDisplay:
        // 核銷碼型
        return exchangeAlert != null && exchangeAlert!.isNotEmpty
            ? '$exchangeAlert' : '確認後需輸入核銷碼，核銷成功恕不退還點數';

      case ExchangeFlowType.posHolding:
      // POS型
        return exchangeAlert != null && exchangeAlert!.isNotEmpty
            ? '$exchangeAlert'
            : '確認後請出示條碼給門市人員，掃碼成功恕不退還點數';

      case ExchangeFlowType.directlyUsedDonation:
        // 公益捐贈
        return exchangeAlert != null && exchangeAlert!.isNotEmpty
            ? '$exchangeAlert'
            : '兌換後即完成捐贈，恕無法取消或退還點數';

      case ExchangeFlowType.branchCodeAvailableWallet:
      case ExchangeFlowType.branchCodeAvailableDisplay:
      case ExchangeFlowType.unknown:
        // 預設訊息
        return '憑證一經刷讀或核銷，恕不退還點數！';
    }
  }

  /// 根據兌換流程類型返回對應的次要訊息（灰色提示文字）
  String _getSecondaryMessage() {
    switch (exchangeFlowType) {
      case ExchangeFlowType.directlyAvailableWallet:
        // 直接儲存至票券匣：決議 UI 不提示
        return '';

      case ExchangeFlowType.branchCodeUsed:
      case ExchangeFlowType.branchCodeUsedDisplay:
        // 核銷碼型票券：提示將手機交由店員
        // return '請將手機交由店員輸入核銷碼。';

      case ExchangeFlowType.posHolding:
      case ExchangeFlowType.directlyUsedDonation:
        // POS型 / 公益捐贈：無次要訊息
        return '';

      case ExchangeFlowType.branchCodeAvailableWallet:
      case ExchangeFlowType.branchCodeAvailableDisplay:
      case ExchangeFlowType.unknown:
        return '';
    }
  }

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
                  width: MediaQuery.of(context).size.width - 70,
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
                        child: const Text(
                          '是否確認兌換',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          _getWarningMessage(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.formFieldErrorBorder,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (_getSecondaryMessage().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Center(
                        child: Text(
                          _getSecondaryMessage(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryValueColor,
                            height: 1.4,
                          ),
                        )),
                      ],
                      const SizedBox(height: 30),
                      // 確認兌換按鈕
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'redeem_click');
                            onConfirm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryHighlightColor,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(
                                color: AppColors.primaryHighlightColor,
                                width: 2,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            '確認兌換',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 取消按鈕
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(
                                color: AppColors.secondaryValueColor,
                                width: 2,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              color: AppColors.secondaryValueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
