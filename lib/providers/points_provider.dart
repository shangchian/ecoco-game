import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/auth_data_model.dart';
import 'auth_provider.dart';
import '/services/interface/i_points_service.dart';
import '../services/online/points_service.dart';
import '../services/mock/points_service_mock.dart';
import '/flavors.dart';

final pointsServiceProvider = Provider<IPointsService>((ref) {
  // Use mock service for internal flavor, real service for production
  if (F.useMockService) {
    return PointsServiceMock();
  }
  return PointsService(
    onTokenRefreshed: (AuthData newAuthData) {
      // Update auth provider state when tokens are refreshed
      // Use Future.microtask to break circular dependency during initialization
      Future.microtask(() {
        if (ref.mounted) {
          ref.read(authProvider.notifier).updateAuthData(newAuthData);
        }
      });
    },
    onRefreshFailed: (String? reason) {
      // Handle token refresh failure
      // Use Future.microtask to break circular dependency during initialization
      Future.microtask(() async {
        if (ref.mounted) {
          // Log the token refresh failure
          log('Token refresh failed - logging out user. Reason: $reason',
              name: 'TokenRefresh');

          // Trigger logout which will clear auth state, profile state, and handle cleanup
          if (reason != null) {
            ref.read(logoutReasonProvider.notifier).state =
                '登入狀態已過期，請重新登入以繼續使用';
          }
          await ref.read(authProvider.notifier).forceLogout();

          // The router's AuthGuard will automatically redirect to LoginRoute
          // when it detects that authProvider state is null after logout
        }
      });
    },
  );
});
