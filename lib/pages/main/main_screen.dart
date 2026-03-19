import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:auto_route/auto_route.dart';
import '../../ecoco_icons.dart';
import '/providers/wallet_provider.dart';
import '/providers/brand_provider.dart';
import '/providers/profile_provider.dart';
import '/providers/auth_provider.dart';
import '/providers/coupon_rules_provider.dart';
import '/pages/app.dart'; // For analyticsRouteObserverProvider
import '/pages/common/loading_overlay.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/widgets/fade_indexed_stack.dart';
import '/utils/snackbar_helper.dart';
import '/utils/system_ui_style_helper.dart';

@RoutePage()
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with AutoRouteAware {
  bool _isLoading = false;
  DateTime? _lastPressedAt;
  AnalyticsRouteObserver? _observer;
  TabsRouter? _tabsRouter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to AutoRouter events from the ROOT router
    _observer = ref.read(analyticsRouteObserverProvider);
    _observer?.subscribe(this, context.routeData);
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when a top-level route (like MerchantDetail) is popped
    // and we return to MainScreen
    // 0 is Home, 2 is Rewards
    final index = _tabsRouter?.activeIndex;
    final authData = ref.read(authProvider);
    
    if (authData != null) {
      if (index == 0) {
        ref.read(profileProvider.notifier).fetchProfile();
        ref.read(walletProvider.notifier).fetchWalletData();
      } else if (index == 2) {
        final repository = ref.read(couponRulesRepositoryProvider);
        repository.syncCouponRules();
        repository.syncCouponStatuses();
        ref.read(walletProvider.notifier).fetchWalletData();
        ref.read(brandRepositoryProvider).syncBrands();
      }
    }
  }

  void setLoading(bool loading) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isLoading = loading);
      });
    }
  }

  void _onTabTap(int index, TabsRouter tabsRouter) {
    final screenNames = [
      'home_view',
      'station_view',
      'points_view',
      'esg_view',
    ];
    if (index >= 0 && index < screenNames.length) {
      FirebaseAnalytics.instance.logScreenView(screenName: screenNames[index]);
    }
    
    // Trigger sync if switching to Home (0) or Rewards (2)
    final authData = ref.read(authProvider);
    if (authData != null) {
      if (index == 0) {
        ref.read(profileProvider.notifier).fetchProfile();
        ref.read(walletProvider.notifier).fetchWalletData();
      } else if (index == 1) {
        // App router will build SitesListView, which handles location on first load.
        // Location will auto-update if permission is granted elsewhere.
      } else if (index == 2) {
         final repository = ref.read(couponRulesRepositoryProvider);
         repository.syncCouponRules();
         repository.syncCouponStatuses();
         ref.read(walletProvider.notifier).fetchWalletData();
         ref.read(brandRepositoryProvider).syncBrands();
      }
    }
    
    tabsRouter.setActiveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiStyleHelper.defaultStyle,
      child: PopScope(
        canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          if (mounted) {
            SnackBarHelper.show(context, '如需關閉應用程式請再次點擊');
          }
          return;
        }
        await SystemNavigator.pop();
      },
      child: Stack(
        children: [
          AutoTabsRouter(
            homeIndex: 0,
            lazyLoad: true,
            routes: [
              HomeRoute(),
              SiteRoute(onLoadingChanged: setLoading),
              RewardsRoute(),
              ProfileRoute(onLoadingChanged: setLoading),
            ],
            builder: (context, child) {
              final tabsRouter = AutoTabsRouter.of(context);
              // Capture tabsRouter for use in didPopNext
              _tabsRouter = tabsRouter;
              
              return Scaffold(
                extendBody: true,
                body: FadeIndexedStack(
                  index: tabsRouter.activeIndex,
                  children: tabsRouter.stack.map((page) => page.buildPage(context)).toList(),
                ),
                bottomNavigationBar: CustomBottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: (index) => _onTabTap(index, tabsRouter),
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: appLocale?.home ?? '',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.location_on),
                      label: appLocale?.search ?? '',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(ECOCOIcons.ecocoSmile),
                      label: appLocale?.rewards ?? '',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person),
                      label: appLocale?.profile ?? '',
                    ),
                  ],
                ),
              );
            },
          ),
          if (_isLoading) const LoadingOverlay(),
        ],
      ),
      ),
    );
  }
}
