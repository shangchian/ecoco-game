import 'package:flutter/foundation.dart';

class StartupMetric {
  static DateTime? _startTime;
  static bool _completed = false;

  static void start() {
    _startTime = DateTime.now();
    _completed = false;
    debugPrint('⏱️ [StartupMetric] 啟動計時開始: $_startTime');
  }

  /// 記錄時間點
  static void checkpoint(String label) {
    if (_startTime == null) return;
    final now = DateTime.now();
    final elapsed = now.difference(_startTime!);
    debugPrint('⏱️ [StartupMetric] $label (+${elapsed.inMilliseconds} ms)');
  }

  static void end() {
    if (_startTime == null || _completed) return;
    
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);
    _completed = true;
    
    debugPrint('⏱️ ----------------------------------------');
    debugPrint('⏱️ [StartupMetric] 耗時:');
    debugPrint('⏱️ ${duration.inMilliseconds} ms (${duration.inSeconds} 秒)');
    debugPrint('⏱️ ----------------------------------------');
  }
}
