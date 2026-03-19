import 'page_code.dart';

/// Deep Link 解析後的資料模型
class DeepLinkData {
  /// 目標頁面代碼
  final PageCode pageCode;

  /// 路徑參數 (例如 couponRuleId, brandId)
  final Map<String, String> pathParams;

  /// Query 參數 (例如 url)
  final Map<String, String> queryParams;

  const DeepLinkData({
    required this.pageCode,
    this.pathParams = const {},
    this.queryParams = const {},
  });

  /// 取得 couponRuleId 參數
  String? get couponRuleId => pathParams['couponRuleId'];

  /// 取得 brandId 參數
  String? get brandId => pathParams['brandId'];

  /// 取得 url 參數
  String? get url => queryParams['url'];

  /// 取得 tab 參數 (for notifications)
  String? get tab => queryParams['tab'];

  @override
  String toString() {
    return 'DeepLinkData(pageCode: ${pageCode.code}, pathParams: $pathParams, queryParams: $queryParams)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeepLinkData &&
        other.pageCode == pageCode &&
        _mapEquals(other.pathParams, pathParams) &&
        _mapEquals(other.queryParams, queryParams);
  }

  @override
  int get hashCode =>
      pageCode.hashCode ^ pathParams.hashCode ^ queryParams.hashCode;

  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
