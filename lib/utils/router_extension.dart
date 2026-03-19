import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

extension StackRouterThrottled on StackRouter {
  static int _lastPushTime = 0;
  static const int _throttleDuration = 800; // ms

  /// Pushes a new route with throttling to prevent double navigation
  Future<T?>? pushThrottled<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    // 1. De-duplication check:
    // If we are already on the target page (top of stack), do nothing.
    // This prevents accidental double-stacking even if throttle expires.
    if (current.name == route.routeName) {
      debugPrint('[Router] Blocked duplicate push: ${route.routeName}');
      return null;
    }

    // 2. Throttling check:
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastPushTime < _throttleDuration) {
      return null;
    }
    _lastPushTime = now;
    return push<T>(route, onFailure: onFailure);
  }
}

extension BuildContextThrottled on BuildContext {
  /// Pushes a new route with throttling via the nearest AutoRouter
  Future<T?>? pushRouteThrottled<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    return AutoRouter.of(this).pushThrottled<T>(route, onFailure: onFailure);
  }
}
