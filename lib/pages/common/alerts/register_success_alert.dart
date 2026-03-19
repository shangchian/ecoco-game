import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/pages/common/loading_overlay.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class RegisterSuccessAlert extends StatefulWidget {
  final Future<void> Function() onConfirm;

  const RegisterSuccessAlert({
    super.key,
    required this.onConfirm,
  });

  @override
  State<RegisterSuccessAlert> createState() => _RegisterSuccessAlertState();
}

class _RegisterSuccessAlertState extends State<RegisterSuccessAlert> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    setState(() => _isLoading = true);
    FirebaseAnalytics.instance.logEvent(name: 'sign_up');
    await widget.onConfirm();
  }

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
                  padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '註冊完成囉!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '歡迎成為可可粉\n趕緊來認識我們的循環宇宙吧',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 確認按鈕
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryHighlightColor,
                            padding: const EdgeInsets.symmetric(vertical: 0),
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
                // ecoco_happy.png 圖示
                Positioned(
                  top: -83,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/ecoco_happy.png',
                      width: 218,
                      height: 153,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading) const Positioned.fill(child: LoadingOverlay()),
        ],
      ),
    );
  }
}
