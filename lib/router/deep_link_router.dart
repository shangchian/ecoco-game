import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth_provider.dart';
import '/providers/pending_deep_link_provider.dart';
import '/services/deep_link/deep_link_data.dart';
import '/services/deep_link/page_code.dart';
import 'app_router.dart';

/// Deep Link 導航執行器 (用於 Ref，例如 Provider 內)
class DeepLinkRouterForRef {
  final Ref ref;

  DeepLinkRouterForRef(this.ref);

  /// 執行導航
  Future<void> navigate(DeepLinkData data) async {
    final router = ref.read(appRouterProvider);
    final authState = ref.read(authProvider);

    if (authState == null) {
      debugPrint('DeepLinkRouter: User not logged in, saving pending link');
      ref.read(pendingDeepLinkProvider.notifier).set(data);
      return;
    }

    await _DeepLinkNavigator.executeNavigation(router, data);
  }
}

/// Deep Link 導航執行器 (用於 WidgetRef，例如 Widget 內)
class DeepLinkRouterForWidgetRef {
  final WidgetRef ref;

  DeepLinkRouterForWidgetRef(this.ref);

  /// 執行導航
  Future<void> navigate(DeepLinkData data) async {
    final router = ref.read(appRouterProvider);
    final authState = ref.read(authProvider);

    if (authState == null) {
      debugPrint('DeepLinkRouter: User not logged in, saving pending link');
      ref.read(pendingDeepLinkProvider.notifier).set(data);
      return;
    }

    await _DeepLinkNavigator.executeNavigation(router, data);
  }
}

/// 共用的導航邏輯
class _DeepLinkNavigator {
  /// 執行導航邏輯
  static Future<void> executeNavigation(
      AppRouter router, DeepLinkData data) async {
    final currentRouteName = router.current.name;

    // 如果當前在認證相關頁面，不進行導航
    if (_isAuthRoute(currentRouteName)) {
      debugPrint(
          'DeepLinkRouter: Skipping navigation, on auth route: $currentRouteName');
      return;
    }

    switch (data.pageCode) {
      // ===== 主頁籤 =====
      case PageCode.home:
        await _navigateToMainTab(router, 0);
        break;
      case PageCode.stationMain:
        await _navigateToMainTab(router, 1);
        break;
      case PageCode.exchangeMain:
        await _navigateToMainTab(router, 2);
        break;
      case PageCode.memberCenter:
        await _navigateToMainTab(router, 3);
        break;

      // ===== 簡單路由 (無參數) =====
      case PageCode.editProfile:
        await _ensureMainRouteAndPush(router, const EditProfileRoute());
        break;
      case PageCode.resetPassword:
        await _ensureMainRouteAndPush(router, const ChangePasswordRoute());
        break;
      case PageCode.myCoupons:
        await _ensureMainRouteAndPush(router, VoucherWalletRoute());
        break;
      case PageCode.favoriteStations:
        await _ensureMainRouteAndPush(router, const FavoriteSitesRoute());
        break;
      case PageCode.pointsHistory:
        await _ensureMainRouteAndPush(router, const PointsHistoryRoute());
        break;
      case PageCode.notifications:
        // Pass the optional tab parameter from queryParams
        await _ensureMainRouteAndPush(router, NotificationsRoute(tab: data.tab));
        break;
      case PageCode.brandsKanban:
        await _ensureMainRouteAndPush(router, const MerchantListRoute());
        break;

      // ===== 帶參數路由 =====
      case PageCode.couponDetail:
        final couponRuleId = data.couponRuleId;
        if (couponRuleId != null && couponRuleId.isNotEmpty) {
          await _ensureMainRouteAndPush(
            router,
            MerchantRewardExchangeByIdRoute(couponRuleId: couponRuleId),
          );
        } else {
          debugPrint('DeepLinkRouter: Missing couponRuleId for couponDetail');
        }
        break;

      case PageCode.brandDetail:
        final brandId = data.brandId;
        if (brandId != null && brandId.isNotEmpty) {
          await _ensureMainRouteAndPush(
            router,
            MerchantDetailByIdRoute(brandId: brandId),
          );
        } else {
          debugPrint('DeepLinkRouter: Missing brandId for brandDetail');
        }
        break;

      case PageCode.termsOfUse:
        final url = data.url;
        if (url != null && url.isNotEmpty) {
          await _ensureMainRouteAndPush(
            router,
            MarkdownViewerRoute(
              title: '使用條款與隱私權政策',
              contentTitle: '使用條款與隱私權政策',
              url: url,
            ),
          );
        } else {
          debugPrint('DeepLinkRouter: Missing url for termsOfUse');
        }
        break;
    }
  }

  /// 導航到主頁籤
  static Future<void> _navigateToMainTab(AppRouter router, int tabIndex) async {
    await _ensureOnMainRoute(router);

    final context = router.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      final tabsRouter = AutoTabsRouter.of(context, watch: false);
      tabsRouter.setActiveIndex(tabIndex);
    }
  }

  /// 確保在 MainRoute 後推送新路由
  static Future<void> _ensureMainRouteAndPush(
      AppRouter router, PageRouteInfo route) async {
    await _ensureOnMainRoute(router);
    await Future.delayed(const Duration(milliseconds: 100));
    await router.push(route);
  }

  /// 確保當前在 MainRoute
  static Future<void> _ensureOnMainRoute(AppRouter router) async {
    final isOnMainRoute = router.stack.any((r) => r.name == 'MainRoute');

    if (!isOnMainRoute) {
      await router.pushAndPopUntil(
        const MainRoute(),
        predicate: (_) => false,
      );
    }
  }

  /// 檢查是否為認證相關路由
  static bool _isAuthRoute(String routeName) {
    return routeName == 'SplashRoute' ||
        routeName == 'LoginRoute' ||
        routeName == 'RegisterRoute' ||
        routeName == 'ForgetPasswordRoute';
  }
}
