/*import 'dart:math';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';

/// 張數型兌換確認 Alert
class QuantityRewardConfirmAlert extends StatelessWidget {
  final int requiredPoints; // 所需點數
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const QuantityRewardConfirmAlert({
    super.key,
    required this.requiredPoints,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 半透明背景
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
            ),
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
                    children: [
                      // 標題
                      const Text(
                        '是否確認兌換',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 橘色使用期限說明
                      const Text(
                        '※抵用券兌換完畢後，請於兌換當日00:01~23:59使用完畢。',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryHighlightColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 主要說明（動態顯示點數）
                      Text(
                        '確認使用$requiredPoints點兌換電子憑證，請於5分鐘內由店員刷讀或核銷憑證進行交易結帳，逾時將自動失效並退回點數。',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 警告文字
                      const Text(
                        '憑證一經刷讀或核銷，恕不退還點數！',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFF5000),
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 確認兌換按鈕
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryHighlightColor,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                            side: const BorderSide(
                              color: AppColors.primaryHighlightColor,
                              width: 2,
                            ),
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
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            backgroundColor: AppColors.primaryDisabledColor,
                            side: const BorderSide(
                              color: AppColors.secondaryValueColor,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              color: AppColors.secondaryValueColor,
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
*/