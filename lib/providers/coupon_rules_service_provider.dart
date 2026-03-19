import 'dart:developer'; // Added
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/flavors.dart';
import '/models/auth_data_model.dart'; // Added
import 'auth_provider.dart'; // Added
import '/services/interface/i_coupon_rules_service.dart';
import '/services/online/coupon_rules_service.dart';
import '/services/mock/coupon_rules_service_mock.dart';

/// Provides the appropriate Coupon Rules Service based on the current flavor
/// - Mock builds: Uses CouponRulesServiceMock for testing with bundled assets
/// - Internal/Production builds: Uses real CouponRulesService
final couponRulesServiceProvider = Provider<ICouponRulesService>((ref) {
  if (F.useMockService) {
    return CouponRulesServiceMock();
  } else {
    return CouponRulesService(
      onTokenRefreshed: (AuthData newAuthData) {
        Future.microtask(() {
          if (ref.mounted) {
            ref.read(authProvider.notifier).updateAuthData(newAuthData);
          }
        });
      },
      onRefreshFailed: (String? reason) {
        Future.microtask(() async {
          if (ref.mounted) {
            log('Token refresh failed - logging out user. Reason: $reason',
                name: 'TokenRefresh');
            if (reason != null) {
              ref.read(logoutReasonProvider.notifier).state =
                  '登入狀態已過期，請重新登入以繼續使用';
            }
            await ref.read(authProvider.notifier).forceLogout();
          }
        });
      },
    );
  }
});
