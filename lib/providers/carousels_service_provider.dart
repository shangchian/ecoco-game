import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/flavors.dart';
import '/services/interface/i_carousels_service.dart';
import '/services/online/carousels_service.dart';
import '/services/mock/carousels_service_mock.dart';

/// Provides the appropriate Carousels Service based on the current flavor
/// - Mock builds: Uses CarouselsServiceMock for testing with bundled assets
/// - Internal/Production builds: Uses real CarouselsService
final carouselsServiceProvider = Provider<ICarouselsService>((ref) {
  if (F.useMockService) {
    return CarouselsServiceMock();
  } else {
    return CarouselsService();
  }
});
