import 'package:flutter/foundation.dart';
import 'deep_link_data.dart';
import 'page_code.dart';

/// URL 解析工具
class LinkParser {
  /// 支援的 custom scheme
  static const String customScheme = 'ecoco';

  /// 解析 Universal Link URL
  /// 例如: https://domain.com/app/coupon/abc123
  static DeepLinkData? parseUniversalLink(Uri uri) {
    return _parseUri(uri);
  }

  /// 解析 Custom Scheme URL
  /// 例如: ecoco://app/coupon/abc123
  static DeepLinkData? parseCustomScheme(Uri uri) {
    if (uri.scheme != customScheme) {
      debugPrint('LinkParser: Invalid scheme ${uri.scheme}, expected $customScheme');
      return null;
    }
    return _parseUri(uri);
  }

  /// 解析任意 URI (自動判斷類型)
  static DeepLinkData? parse(Uri uri) {
    if (uri.scheme == customScheme) {
      return parseCustomScheme(uri);
    } else if (uri.scheme == 'https' || uri.scheme == 'http') {
      return parseUniversalLink(uri);
    }
    debugPrint('LinkParser: Unsupported scheme ${uri.scheme}');
    return null;
  }

  /// 從字串解析
  static DeepLinkData? parseString(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint('LinkParser: Failed to parse URL: $url');
      return null;
    }
    return parse(uri);
  }

  /// 解析推播通知資料
  /// 支援兩種格式:
  /// 1. { "pageCode": "COUPON_DETAIL", "params": { "couponRuleId": "abc123" } }
  /// 2. { "actionLink": "ecoco://app/coupon/abc123" }
  static DeepLinkData? parsePushNotification(Map<String, dynamic> data) {
    // 格式 1: pageCode + params
    /*
      {
         "data": {
           "actionType": "APP_PAGE", (固定)
           "pageCode": "COUPON_DETAIL",
           "params": {
             "couponRuleId": "abc123"
           }
         }
       }
     */
    if (data.containsKey('pageCode')) {
      final pageCodeStr = data['pageCode'] as String?;
      if (pageCodeStr == null) return null;

      final pageCode = PageCode.fromCode(pageCodeStr);
      if (pageCode == null) {
        debugPrint('LinkParser: Unknown pageCode: $pageCodeStr');
        return null;
      }

      final params = data['params'] as Map<String, dynamic>? ?? {};
      final pathParams = <String, String>{};

      for (final entry in params.entries) {
        pathParams[entry.key] = entry.value.toString();
      }

      return DeepLinkData(
        pageCode: pageCode,
        pathParams: pathParams,
      );
    }

    // 格式 2: actionLink (URL 格式)
    if (data.containsKey('actionLink')) {
      final actionLink = data['actionLink'] as String?;
      if (actionLink == null) return null;
      return parseString(actionLink);
    }

    // 格式 3: 如果是個人訊息的 payload，直接導向通知中心的個人分頁
    if (data.containsKey('personal')) {
      return parseString('ecoco://app/notifications?tab=personal');
    }

    debugPrint('LinkParser: Push data missing pageCode or actionLink');
    return null;
  }

  /// 內部解析邏輯
  static DeepLinkData? _parseUri(Uri uri) {
    // 組合路徑: 對於 custom scheme，host 是路徑的一部分
    // ecoco://app/home -> path = /home, host = app
    // https://domain.com/app/home -> path = /app/home
    String path;
    if (uri.scheme == customScheme) {
      // Custom scheme: host + path
      path = '/${uri.host}${uri.path}';
    } else {
      // Universal link: 直接使用 path
      path = uri.path;
    }

    // 清理路徑 (移除結尾斜線)
    if (path.endsWith('/') && path.length > 1) {
      path = path.substring(0, path.length - 1);
    }

    // 取得 PageCode
    final pageCode = PageCode.fromPath(path);
    if (pageCode == null) {
      debugPrint('LinkParser: Unknown path: $path');
      return null;
    }

    // 提取路徑參數
    final pathParams = _extractPathParams(path, pageCode);

    // Query 參數
    final queryParams = uri.queryParameters;

    return DeepLinkData(
      pageCode: pageCode,
      pathParams: pathParams,
      queryParams: queryParams,
    );
  }

  /// 提取路徑參數
  static Map<String, String> _extractPathParams(String path, PageCode pageCode) {
    final basePath = pageCode.basePath;

    switch (pageCode) {
      case PageCode.couponDetail:
        // /app/coupon/{couponRuleId}
        if (path.length > basePath.length + 1) {
          final id = path.substring(basePath.length + 1);
          return {'couponRuleId': id};
        }
        return {};

      case PageCode.brandDetail:
        // /app/brand/{brandId}
        if (path.length > basePath.length + 1) {
          final id = path.substring(basePath.length + 1);
          return {'brandId': id};
        }
        return {};

      default:
        return {};
    }
  }
}
