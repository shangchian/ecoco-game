import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/router/app_router.dart';
import '/router/deep_link_router.dart';
import '/utils/deep_link_handler.dart';
import '/providers/auth_provider.dart';
import '/services/deep_link/link_parser.dart';
import '/providers/location_provider.dart';
import '/providers/site_provider.dart';
import 'package:drift/drift.dart' show TableUpdate;
import '/providers/carousel_provider.dart';
import '/providers/wallet_provider.dart';
import '/providers/app_database_provider.dart';
import '/providers/notifications_data_provider.dart';
import '/providers/app_mode_provider.dart';

final analyticsRouteObserverProvider = Provider((ref) => AnalyticsRouteObserver());

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  late final DeepLinkHandler deepLinkHandler;
  
  /// 監聽 auth 狀態變化，處理 session 過期自動登出與登入同步
  void _setupAuthListener() {
    ref.listenManual(authProvider, (previous, next) {
      // 處理登出轉換
      if (previous != null && next == null) {
        _handleSessionExpired();
      }
      
      // 處理登入轉換：登入後開始同步推播（非同步處理，不阻塞導航）
      if (previous == null && next != null) {
        Future.microtask(() {
          try {
            ref.read(notificationsDataRepositoryProvider).syncNotifications(forceRefresh: true);
          } catch (e) {
            debugPrint('Failed to sync notifications on login: $e');
          }
        });
      }
    });
  }

  /// 監聽一般模式與遊戲模式切換
  void _setupModeListener() {
    ref.listenManual(appModeStateProvider, (previous, next) {
      if (previous == next) return;
      final router = ref.read(appRouterProvider);
      if (next == AppMode.game) {
        router.replaceAll([const GameHomeRoute()]);
      } else {
        router.replaceAll([const MainRoute()]);
      }
    });
  }

  /// 處理 session 過期，顯示提示並導航到登入頁
  void _handleSessionExpired() {
    final router = ref.read(appRouterProvider);
    final stack = router.stack.map((e) => e.name).toList();
    log('APP: Handling session expired. Current stack: $stack');
    
    // 導航到登入頁
    router.replaceAll([LoginRoute(isLogout: true)]);
    log('APP: Navigation to LoginRoute(isLogout: true) requested');
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage, isColdStart: true);
    }

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message, isColdStart: false));
  }

  void _handleMessage(RemoteMessage message, {bool isColdStart = false}) {
    debugPrint(
        'App: Received push notification: ${message.data}, coldStart: $isColdStart');

    // 記錄 app_push 事件到 Firebase Analytics
    FirebaseAnalytics.instance.logEvent(name: 'app_push');

    // 使用 addPostFrameCallback 確保在冷啟動時 Router 已經準備就緒
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final delayMs = isColdStart ? 2000 : 200;
      await Future.delayed(Duration(milliseconds: delayMs));

      // 解析推播資料
      final data = LinkParser.parsePushNotification(message.data);
      if (data != null) {
        debugPrint('App: Navigating to ${data.pageCode.code}');
        final router = DeepLinkRouterForWidgetRef(ref);
        router.navigate(data);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setupInteractedMessage();
    deepLinkHandler = ref.read(deepLinkHandlerProvider);
    deepLinkHandler.init();
    _setupAuthListener();
    _setupModeListener();

    // 啟動時觸發一次同步 (若快取未過期則不會真正發出請求)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider) != null) {
        try {
          final repository = ref.read(notificationsDataRepositoryProvider);
          repository.syncNotifications();
        } catch (e) {
          debugPrint('Failed to initial sync notifications: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleAppResume();
    }
  }

  Future<void> _handleAppResume() async {
    // Only refresh for authenticated users
    final authData = ref.read(authProvider);
    if (authData != null) {
      // Update location when app resumes (fire-and-forget)
      ref.read(userLocationProvider.notifier).getUserLocation(requestPermission: false);

      // Force Drift to re-evaluate streams since the background FCM isolate might have modified the database
      try {
        final db = ref.read(appDatabaseProvider);
        db.notifyUpdates({const TableUpdate('notifications')});
      } catch (e) {
        debugPrint('Failed to notify database updates: $e');
      }

      // Silently refresh sites in background
      // Errors are logged but don't affect UI
      ref.read(sitesProvider.notifier).refresh();

      // Refresh carousels in background
      ref.read(mainCarouselsProvider.notifier).refresh();

      // Refresh wallet data in background
      ref.read(walletProvider.notifier).fetchWalletData();

      // Refresh notifications in background
      try {
        final repository = ref.read(notificationsDataRepositoryProvider);
        repository.syncNotifications(forceRefresh: true);
      } catch (e) {
        debugPrint('Failed to sync notifications on resume: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "",
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'TW'),
      ],
      debugShowCheckedModeBanner: false,
      routerConfig: ref.read(appRouterProvider).config(
            navigatorObservers: () => [ref.read(analyticsRouteObserverProvider)],
          ),
    );
  }
}

class AnalyticsRouteObserver extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      FirebaseAnalytics.instance.logScreenView(
        screenName: route.settings.name ?? '',
        screenClass: route.runtimeType.toString(),
      );
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      FirebaseAnalytics.instance.logScreenView(
        screenName: route.settings.name ?? '',
        screenClass: route.runtimeType.toString(),
      );
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute?.settings.name != null) {
      FirebaseAnalytics.instance.logScreenView(
        screenName: newRoute!.settings.name ?? '',
        screenClass: newRoute.runtimeType.toString(),
      );
    }
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    super.didInitTabRoute(route, previousRoute);
    FirebaseAnalytics.instance.logScreenView(
      screenName: route.name,
      screenClass: route.runtimeType.toString(),
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
    FirebaseAnalytics.instance.logScreenView(
      screenName: route.name,
      screenClass: route.runtimeType.toString(),
    );
  }
}
