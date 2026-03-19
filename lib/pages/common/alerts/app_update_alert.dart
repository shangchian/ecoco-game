import 'dart:math';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';

class AppUpdateAlert extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const AppUpdateAlert({
    super.key,
    required this.onConfirm,
    this.onCancel,
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
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '版本更新',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '為提供更順暢的服務體驗，請立即更新 ECOCO App 至最新版本；\n若無法更新至最新版本，請先更新手機作業系統至 Android 7.0.0 或 iOS 15.6（含）以上版本，以確保你的使用權益。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 立即更新按鈕
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pop(context); // 強制更新不關閉視窗，直到 App 更新重啟
                            onConfirm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryHighlightColor,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                            side: const BorderSide(
                              color: AppColors.primaryHighlightColor,
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            '立即更新',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (onCancel != null) ...[
                        const SizedBox(height: 8),
                        // 稍後提醒按鈕
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onCancel!();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              backgroundColor: AppColors.primaryDisabledColor,
                              side: const BorderSide(
                                color: AppColors.secondaryValueColor,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '稍後提醒',
                              style: TextStyle(
                                color: AppColors.secondaryValueColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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
