import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import '/services/deep_link/link_parser.dart';
import '/services/deep_link/deep_link_data.dart';
import '/services/deep_link/page_code.dart';
import '/router/deep_link_router.dart';

final deepLinkHandlerProvider = Provider((ref) => DeepLinkHandler(ref));

class DeepLinkHandler {
  final Ref ref;
  static const MethodChannel _platform = MethodChannel("com.dream.ECOCO");
  StreamSubscription<Uri>? _linkSubscription;
  bool _isInitialized = false;

  DeepLinkHandler(this.ref);

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _setupMethodChannel();
    _setupDeepLinkListener();

    // 處理冷啟動時的初始連結
    final initialUri = await AppLinks().getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }
  }

  /// 設置 iOS Siri Shortcut / MethodChannel
  void _setupMethodChannel() {
    _platform.setMethodCallHandler((call) async {
      if (call.method == 'handleShortcut') {
        try {
          final args = Map<String, dynamic>.from(call.arguments);
          _handleShortcut(args);
        } catch (e) {
          debugPrint('DeepLinkHandler: Error handling Siri shortcut: $e');
        }
      }
      return null;
    });
  }

  /// 設置 Deep Link 監聽
  void _setupDeepLinkListener() {
    _linkSubscription = AppLinks().uriLinkStream.listen((Uri uri) {
      _handleUri(uri);
    });
  }

  /// 處理 URI (Universal Link 或 Custom Scheme)
  void _handleUri(Uri uri) {
    debugPrint('DeepLinkHandler: Received URI: $uri');

    // 1. 記錄 deep_link_open
    try {
      FirebaseAnalytics.instance.logEvent(
        name: 'deep_link_open',
        parameters: {'url': uri.toString()},
      );

      // 2. 解析並記錄 campaign_open (UTM 參數)
      final queryParams = uri.queryParameters;
      final utmSource = queryParams['utm_source'] ?? queryParams['source'];
      final utmMedium = queryParams['utm_medium'] ?? queryParams['medium'];
      final utmCampaign = queryParams['utm_campaign'] ?? queryParams['campaign'];

      if (utmSource != null || utmMedium != null || utmCampaign != null) {
        final campaignParams = <String, Object>{};
        if (utmSource != null) campaignParams['source'] = utmSource;
        if (utmMedium != null) campaignParams['medium'] = utmMedium;
        if (utmCampaign != null) campaignParams['campaign'] = utmCampaign;
        
        FirebaseAnalytics.instance.logEvent(
          name: 'campaign_open',
          parameters: campaignParams,
        );
      }
    } catch (e) {
      debugPrint('DeepLinkHandler: Error logging GA events: $e');
    }

    final data = LinkParser.parse(uri);
    if (data != null) {
      _navigate(data);
    } else {
      debugPrint('DeepLinkHandler: Failed to parse URI: $uri');
    }
  }

  /// 處理 Siri Shortcut
  void _handleShortcut(Map<String, dynamic> args) {
    final type = args['type'] as String?;
    if (type == null) return;

    debugPrint('DeepLinkHandler: Received shortcut type: $type');

    final pageCode = PageCode.fromCode(type);
    if (pageCode != null) {
      _navigate(DeepLinkData(pageCode: pageCode));
    } else {
      debugPrint('DeepLinkHandler: Unknown shortcut type: $type');
    }
  }

  /// 執行導航
  void _navigate(DeepLinkData data) {
    debugPrint('DeepLinkHandler: Navigating to ${data.pageCode.code}');

    // 等待 app 準備好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = DeepLinkRouterForRef(ref);
      router.navigate(data);
    });
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
