import 'package:auto_route/auto_route.dart';
import '/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth_provider.dart';

class AuthGuard extends AutoRouteGuard {
  final Ref ref;

  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // 允許 SplashPage 通過，由 SplashPage 負責初始化和導航
    final isFromSplash = router.current.name == SplashRoute.name;
    if (isFromSplash) {
      resolver.next(true);
      return;
    }

    // 使用 ref.read 讀取當前認證狀態（SplashPage 已完成初始化）
    final authState = ref.read(authProvider);
    final isOnLoginRoute = router.current.name == LoginRoute.name;

    if (authState != null || isOnLoginRoute) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(LoginRoute(isLogout: true), replace: true);
    }
  }
} 
