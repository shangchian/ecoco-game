import 'dart:developer';

class AppLogger {
  static void debug(String message) {
    final ts = DateTime.now().toIso8601String();
    log('[$ts] [DEBUG] $message');
  }

  static void info(String message) {
    final ts = DateTime.now().toIso8601String();
    log('[$ts] [INFO] $message');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    final ts = DateTime.now().toIso8601String();
    log(
      '[$ts] [ERROR] $message',
      error: error,
      stackTrace: stack,
    );
  }
}
