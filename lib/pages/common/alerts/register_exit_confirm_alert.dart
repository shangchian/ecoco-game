import 'dart:math';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';

class RegisterExitConfirmAlert extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onExit;

  const RegisterExitConfirmAlert({
    super.key,
    required this.onContinue,
    required this.onExit,
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
                      const Text(
                        '尚未完成註冊',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '差一步就完成了\n是否要繼續填寫？',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 繼續填寫按鈕
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onContinue();
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
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            '繼續填寫',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 離開按鈕
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onExit();
                          },
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
                            '離開',
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
