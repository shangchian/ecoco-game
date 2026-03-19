import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '/utils/router_extension.dart';

extension RouterAnalyticsExtension on StackRouter {
  /// 記錄 GA4 button_click 事件
  void logButtonClickEvent(PageRouteInfo route, String buttonName) {
    try {
      FirebaseAnalytics.instance.logEvent(
        name: 'button_click',
        parameters: {
          'button_name': buttonName,
          'page_name': route.routeName,
        },
      );
      if (kDebugMode) {
        print('GA: Logged button_click [button_name: $buttonName, page_name: ${route.routeName}]');
      }
    } catch (e) {
      debugPrint('Error logging button_click event: $e');
    }
  }

  /// 替代 push，自動記錄 GA4
  Future<T?> pushWithTracking<T extends Object?>(PageRouteInfo route, {String? buttonName}) {
    logButtonClickEvent(route, buttonName ?? route.routeName);
    return push<T>(route);
  }

  /// 替代 pushThrottled，自動記錄 GA4 並保留 throttle 行為
  Future<T?>? pushThrottledWithTracking<T extends Object?>(PageRouteInfo route, {String? buttonName}) {
    logButtonClickEvent(route, buttonName ?? route.routeName);
    return pushThrottled<T>(route);
  }

  /// 替代 pushAndPopUntil，自動記錄 GA4
  Future<T?> pushAndPopUntilWithTracking<T extends Object?>(
    PageRouteInfo route, {
    required RoutePredicate predicate,
    String? buttonName,
  }) {
    logButtonClickEvent(route, buttonName ?? route.routeName);
    return pushAndPopUntil<T>(route, predicate: predicate);
  }

  /// 替代 replace，自動記錄 GA4
  Future<T?> replaceWithTracking<T extends Object?>(PageRouteInfo route, {required String buttonName}) {
    logButtonClickEvent(route, buttonName);
    return replace<T>(route);
  }
}
