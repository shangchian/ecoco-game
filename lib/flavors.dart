enum Flavor {
  mock,
  internal,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.mock:
        return 'ECOCO 獨享版';
      case Flavor.internal:
        return 'ECOCO Test';
      case Flavor.production:
        return 'ECOCO';
      default:
        return 'title';
    }
  }

  /// Use mock service for testing without real server connection
  /// - mock: true (no server, local mock data only)
  /// - internal: false (uses test server)
  /// - production: false (uses production server)
  static bool get useMockService {
    switch (appFlavor) {
      case Flavor.mock:
        return true; // Use mock service with no server connection
      case Flavor.internal:
        return false; // Use real service with test server
      case Flavor.production:
        return false; // Use real service with production server
      default:
        return false;
    }
  }

  /// API base URL for each flavor
  /// - mock: empty (not used, uses mock data)
  /// - internal: test server
  /// - production: production server
  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Not used for mock flavor
      case Flavor.internal:
        return 'https://api.funleadchange.com/app';
      case Flavor.production:
        return 'https://api.ecocogroup.com/app';
      default:
        return '';
    }
  }

  /// API base URL for site status endpoint
  /// 開會決議：在測試時採用正式站的資料
  /// Special case: Both internal and production flavors use production API
  /// This is the ONLY endpoint with this special requirement.
  static String get siteStatusApiBaseUrl {
    // Always return production URL regardless of flavor
    return 'https://api.ecocogroup.com/app';
  }

  /// AWS S3 URL for member delete reasons JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get deleteReasonsUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        return 'https://static.ecoco.xyz/develop/app/share/member-delete-reasons.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/member-delete-reasons.json';
      default:
        return '';
    }
  }

  /// AWS S3 URL for sites JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get sitesUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        // 開會決議使用正式站的資訊，進行debug
        //return 'https://static.ecoco.xyz/develop/app/share/sites.json';
        return 'https://static.ecoco.xyz/production/app/share/sites.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/sites.json';
      default:
        return '';
    }
  }

  /// AWS S3 URL for area/district JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get areaDistrictUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        return 'https://static.ecoco.xyz/develop/app/share/area-district-list.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/area-district-list.json';
      default:
        return '';
    }
  }

  /// AWS S3 URL for brands JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get brandsUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        return 'https://static.ecoco.xyz/develop/app/share/brands.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/brands.json';
      default:
        return '';
    }
  }

  /// AWS S3 URL for coupon rules JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get couponRulesUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        return 'https://static.ecoco.xyz/develop/app/share/coupon-rules.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/coupon-rules.json';
      default:
        return '';
    }
  }

  /// AWS S3 URL for carousels JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get carouselsUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        return 'https://static.ecoco.xyz/develop/app/share/carousels.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/carousels.json';
      default:
        return '';
    }
  }

  /// AWS S3 URL for notifications JSON
  /// - mock: empty (use bundled asset only)
  /// - internal: develop environment
  /// - production: production environment
  static String get notificationsUrl {
    switch (appFlavor) {
      case Flavor.mock:
        return ''; // Use bundled asset only
      case Flavor.internal:
        return 'https://static.ecoco.xyz/develop/app/share/notifications.json';
      case Flavor.production:
        return 'https://static.ecoco.xyz/production/app/share/notifications.json';
      default:
        return '';
    }
  }

}
