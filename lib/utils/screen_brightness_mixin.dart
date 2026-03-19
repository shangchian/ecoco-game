import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:screen_brightness/screen_brightness.dart';

/// Mixin 用於在顯示 QR Code 時自動調整螢幕亮度。
///
/// 使用方式:
/// 1. 在 State class 加入 `with ScreenBrightnessMixin`
/// 2. 在 initState 呼叫 `setBrightnessToMax()`
/// 3. 在 dispose 呼叫 `restoreOriginalBrightness()`
mixin ScreenBrightnessMixin<T extends StatefulWidget> on State<T> {
  bool _brightnessRestored = false;

  /// 將螢幕亮度設定為最高 (1.0)。
  Future<void> setBrightnessToMax() async {
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(1.0);
      log('[ScreenBrightnessMixin] Brightness set to max');
    } catch (e) {
      log('[ScreenBrightnessMixin] Failed to set brightness: $e');
    }
  }

  /// 恢復原本的螢幕亮度。
  /// 應在 dispose() 中於 super.dispose() 之前呼叫。
  Future<void> restoreOriginalBrightness() async {
    if (_brightnessRestored) return;
    _brightnessRestored = true;

    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
      log('[ScreenBrightnessMixin] Brightness restored');
    } catch (e) {
      log('[ScreenBrightnessMixin] Failed to restore brightness: $e');
    }
  }
}
