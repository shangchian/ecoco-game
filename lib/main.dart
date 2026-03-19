import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import '/services/firebase_messaging_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/providers/shared_preferences_provider.dart';
import 'package:ecoco_app/feature/game/services/game_auth_service.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database for Asia/Taipei
  tz.initializeTimeZones();

  // Enable Edge-to-Edge UI for Android 10+
  // This allows the app to draw behind the system bars
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 鎖定應用程式為直立方向
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 設定全域系統 UI 樣式
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android: 黑圖示
    statusBarBrightness: Brightness.light,    // iOS: 黑圖示
    systemNavigationBarColor: Colors.white,   // 底部導航列: 白色
    systemNavigationBarIconBrightness: Brightness.dark, // 底部導航列: 黑圖示
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics _ = FirebaseAnalytics.instance;

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    // Use debug provider in debug mode, otherwise use platform-specific providers
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleDeviceCheckProvider(),
  );

  // Set debug token for development (only works in debug mode)
  if (kDebugMode) {
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      log('FCM Token: $fcmToken');
    } catch (e) {
      log('Failed to get FCM token: $e');
      fcmToken = null;
    }
  }

  FlutterError.onError = (errorDetails) {
    if (errorDetails.exception is NotAuthenticatedException) {
      return;
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (error is NotAuthenticatedException) {
      return true;
    }
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Pre-load SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  
  await FirebaseMessagingService.init(container);

  // Initialize GameAuthService to start watching for auth changes
  container.read(gameAuthServiceProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: App(),
    ),
  );
}
