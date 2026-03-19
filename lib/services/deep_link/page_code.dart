import 'package:collection/collection.dart';

/// 定義所有可透過 Deep Link / Universal Link 導航的頁面代碼
enum PageCode {
  home('HOME', '/app/home'),
  stationMain('SITE_MAIN', '/app/station'),
  exchangeMain('EXCHANGE_MAIN', '/app/exchange'),
  memberCenter('MEMBER_CENTER', '/app/profile'),
  editProfile('EDIT_PROFILE', '/app/edit-profile'),
  resetPassword('RESET_PASSWORD', '/app/change-password'),
  myCoupons('MY_COUPONS', '/app/vouchers'),
  favoriteStations('FAVORITE_SITES', '/app/favorite-sites'),
  pointsHistory('POINTS_HISTORY', '/app/points-history'),
  couponDetail('COUPON_DETAIL', '/app/coupon'),
  notifications('NOTIFICATIONS', '/app/notifications'),
  brandsKanban('BRANDS_KANBAN', '/app/brands'),
  brandDetail('BRAND_DETAIL', '/app/brand'),
  termsOfUse('TERMS_OF_USE', '/app/terms');

  /// 頁面代碼字串 (用於 API/推播)
  final String code;

  /// 基礎路徑 (用於 URL 解析)
  final String basePath;

  const PageCode(this.code, this.basePath);

  /// 從代碼字串取得 PageCode
  static PageCode? fromCode(String code) {
    return PageCode.values.firstWhereOrNull((e) => e.code == code);
  }

  /// 從 URL 路徑取得 PageCode
  static PageCode? fromPath(String path) {
    // 先嘗試完全匹配
    final exactMatch =
        PageCode.values.firstWhereOrNull((e) => path == e.basePath);
    if (exactMatch != null) return exactMatch;

    // 嘗試前綴匹配 (用於帶參數的路徑，如 /app/coupon/abc123)
    return PageCode.values.firstWhereOrNull(
      (e) => path.startsWith('${e.basePath}/'),
    );
  }

  /// 是否需要路徑參數
  bool get requiresPathParam {
    return this == PageCode.couponDetail || this == PageCode.brandDetail;
  }

  /// 是否需要 query 參數
  bool get requiresQueryParam {
    return this == PageCode.termsOfUse;
  }
}
