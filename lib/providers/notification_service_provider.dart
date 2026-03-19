import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/flavors.dart';
import '/models/auth_data_model.dart';
import 'auth_provider.dart';
import '/services/interface/i_notification_service.dart';
import '/services/online/notification_service.dart';
import '/services/mock/notification_service_mock.dart';

part 'notification_service_provider.g.dart';

/// Provides the appropriate Notification Service based on the current flavor
/// - Mock builds: Uses NotificationServiceMock for testing
/// - Internal/Production builds: Uses real NotificationService with token hooks
@Riverpod(keepAlive: true)
INotificationService notificationService(Ref ref) {
  if (F.useMockService) {
    return NotificationServiceMock(); // Mock doesn't need callbacks usually
  } else {
    // Note: functional providers don't have direct access to 'this' context of a class.
    // Ref is valid during the build.
    // However, for callbacks, we need to be careful about accessing Ref after disposal?
    // keepAlive: true ensures it persists.
    
    return NotificationService(
      onTokenRefreshed: (AuthData newAuthData) {
        // Use Future.microtask to break circular dependency during initialization if any
        Future.microtask(() {
          // Assuming ref is safe to use as long as provider is alive
          try {
             ref.read(authProvider.notifier).updateAuthData(newAuthData);
          } catch (e) {
             log('Error updating auth data in notification service: $e');
          }
        });
      },
      onRefreshFailed: (String? reason) {
        Future.microtask(() async {
          try {
            log('Token refresh failed in notification service - logging out user. Reason: $reason',
                name: 'TokenRefresh');
            
            // Trigger logout which will clear auth state, profile state, and handle cleanup
            if (reason != null) {
              ref.read(logoutReasonProvider.notifier).state =
                  '登入狀態已過期，請重新登入以繼續使用';
            }
            // Force logout
            await ref.read(authProvider.notifier).forceLogout();
            
          } catch (e) {
             log('Error during logout in notification service: $e');
          }
        });
      },
    );
  }
}
