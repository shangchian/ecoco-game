import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/flavors.dart';
import '/services/interface/i_brands_service.dart';
import '/services/online/brands_service.dart';
import '/services/mock/brands_service_mock.dart';

/// Provides the appropriate Brands Service based on the current flavor
/// - Mock builds: Uses BrandsServiceMock for testing with bundled assets
/// - Internal/Production builds: Uses real BrandsService
final brandsServiceProvider = Provider<IBrandsService>((ref) {
  if (F.useMockService) {
    return BrandsServiceMock();
  } else {
    return BrandsService();
  }
});
