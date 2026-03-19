import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/utils/error_messages.dart';

/// 集中式 SnackBar 工具類別，統一全 App 的 SnackBar 樣式。
///
/// 使用方式:
/// ```dart
/// SnackBarHelper.show(context, '訊息內容');
/// SnackBarHelper.show(context, '自訂時間', duration: Duration(seconds: 3));
/// SnackBarHelper.showWarning(context, '警告訊息');
/// SnackBarHelper.showWithWidget(context, child: Text.rich(...), onTap: () => ...);
/// ```
class SnackBarHelper {
  SnackBarHelper._();

  static String? _lastMessage;
  static DateTime? _lastShownTime;
  static const Duration _debounceDuration = Duration(milliseconds: 2000);

  static bool _shouldShow(String message) {
    final now = DateTime.now();
    if (_lastMessage == message &&
        _lastShownTime != null &&
        now.difference(_lastShownTime!) < _debounceDuration) {
      return false;
    }
    _lastMessage = message;
    _lastShownTime = now;
    return true;
  }

  /// 警告色（橘色）
  static const Color _warningColor = Color(0xFFFF5000);

  /// 顯示統一樣式的 SnackBar。
  ///
  /// 參數:
  /// - [context]: BuildContext
  /// - [message]: 要顯示的訊息
  /// - [duration]: SnackBar 顯示時間（預設 5 秒）
  /// - [margin]: 自訂 SnackBar 的 margin
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
    EdgeInsetsGeometry? margin,
  }) {
    final displayMessage = ErrorMessages.getDisplayMessage(message);
    if (!_shouldShow(displayMessage)) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        context: context,
        child: Text(
          displayMessage,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.snackbarBackgroundColor,
        duration: duration,
        margin: margin,
      ),
    );
  }

  /// 顯示警告樣式的 SnackBar（橘色背景）。
  ///
  /// 參數:
  /// - [context]: BuildContext
  /// - [message]: 要顯示的訊息
  /// - [duration]: SnackBar 顯示時間（預設 3 秒）
  /// - [margin]: 自訂 SnackBar 的 margin
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    EdgeInsetsGeometry? margin,
  }) {
    final displayMessage = ErrorMessages.getDisplayMessage(message);
    if (!_shouldShow(displayMessage)) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        context: context,
        child: Text(
          displayMessage,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: _warningColor,
        duration: duration,
        margin: margin,
      ),
    );
  }

  /// 顯示自訂內容的 SnackBar。
  ///
  /// 參數:
  /// - [context]: BuildContext
  /// - [child]: 要顯示的 Widget
  /// - [onTap]: 點擊內容區域時的 callback
  /// - [duration]: SnackBar 顯示時間（預設 5 秒）
  /// - [margin]: 自訂 SnackBar 的 margin
  static void showWithWidget(
    BuildContext context, {
    required Widget child,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 5),
    EdgeInsetsGeometry? margin,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        context: context,
        child: child,
        onTap: onTap,
        backgroundColor: AppColors.snackbarBackgroundColor,
        duration: duration,
        margin: margin,
      ),
    );
  }

  /// 建構 SnackBar Widget
  static SnackBar _buildSnackBar({
    required BuildContext context,
    required Widget child,
    required Color backgroundColor,
    required Duration duration,
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
  }) {
    // 右側結構佔用空間：
    //   右邊距 (16) + Icon 寬度 (16) + Icon 與文字間距 (20) = 52
    //
    // 左側結構佔用空間：
    //   左邊距 (26)
    //
    // 因為 52 > 26，為了保持置中，左右兩側都必須留保留 52 的空間。
    // (這也同時滿足了左側至少 26 的需求)
    const textHorizontalPadding = 52.0;

    return SnackBar(
      content: Stack(
        alignment: Alignment.center,
        children: [
          // 置中的文字區域
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: textHorizontalPadding),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onTap?.call();
              },
              child: child,
            ),
          ),
          // 右側關閉按鈕
          Positioned(
            right: 16,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      margin: margin ?? const EdgeInsets.all(16),
      // SnackBar 本身的 padding 只保留垂直部分，水平由 Stack 內部控制
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
