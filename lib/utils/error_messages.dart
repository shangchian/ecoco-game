class ErrorMessages {
  static final Map<String, String> errorMap = {
    // 登入相關
    '帳號密碼錯誤': '請確認輸入的帳號及密碼是否正確',
    '帳號已被鎖定': '您的帳號已被鎖定，請聯絡客服人員',
    '操作過於頻繁': '操作過於頻繁，請稍後再試',
    '輸入的帳號密碼不匹配': '請確認輸入的帳號及密碼是否正確',
    '此帳號因安全因素而被封鎖': '您的帳號已被鎖定，請聯絡客服人員',

    // 註冊相關
    '此手機門號尚未註冊': '請確認輸入的手機門號是否正確',
    '驗證碼錯誤': '請確認輸入的驗證碼是否正確',
    '會員註冊尚未完成': '您尚未註冊完成，離開後將從頭開始且資料不會記憶，確定要離開註冊程序嗎？',
    '此帳號已註冊過': '請使用該帳號直接登入，如果你不記得密碼請使用忘記密碼功能',

    // 忘記密碼相關
    '此帳號未註冊': '請先完成註冊程序',
    '驗證碼輸入錯誤': '請檢查驗證碼是否正確',

    // 隱私權政策相關
    '隱私權政策': '請先閱讀並同意服務條款與隱私權政策',

    // 站點收藏相關
    '已達收藏上限': '您最多可收藏5個站點\n請先取消其他收藏再試',

    // 註冊 Token 相關
    'Token expired': '驗證已過期，請重新進行手機驗證',
    'Token refresh failed': '驗證已過期，請重新進行手機驗證',
    'Password is required': '請先設定密碼',
  };

  // 取得錯誤訊息的方法
  static Set<String> getMessage(String errorKey, {String defaultTitle = '發生未預期錯誤'}) {
    errorKey = errorKey.replaceAll('Exception: ', '');
    final errMsg = errorMap[errorKey];
    if (errMsg == null) {
      return {defaultTitle, '系統暫時無法完成您的操作，請稍後再試'};
    } else {
      return {errorKey, errMsg};
    }
  }

  /// 取得要顯示在 UI 上的錯誤訊息（過濾未預期的後台錯誤訊息）
  static String getDisplayMessage(String errorKey) {
    errorKey = errorKey.replaceAll('Exception: ', '');
    
    // 1. 若有定義在 errorMap 的固定對應，直接使用
    if (errorMap.containsKey(errorKey)) {
      return errorMap[errorKey]!;
    }
    
    // 2. 判斷是否包含未預期的伺服器錯誤 (例如 HTTP 4xx, 5xx 狀態碼，或常見英文錯誤)
    final lowerKey = errorKey.toLowerCase();
    
    // 利用正規表達式檢查是否包含 400~599 的數字
    final hasHttpErrorCode = RegExp(r'\b[45]\d{2}\b').hasMatch(lowerKey);
    
    final isSystemError = hasHttpErrorCode ||
        lowerKey.contains('gateway') ||
        lowerKey.contains('timeout') ||
        lowerKey.contains('internal server error') ||
        lowerKey.contains('bad request') ||
        lowerKey.contains('unauthorized') ||
        lowerKey.contains('forbidden') ||
        lowerKey.contains('not found') ||
        lowerKey.contains('too many requests') ||
        lowerKey.contains('<html>') ||
        lowerKey.contains('</') ||
        lowerKey.contains('exception') ||
        lowerKey.contains('sql') ||
        lowerKey.contains('database');

    // 如果判定為系統層級的未預期錯誤，回傳統一文案，不要把後台細節吐給使用者
    if (isSystemError) {
      return '系統暫時無法完成您的操作，請稍後再試';
    }

    // 3. 其他未攔截的提示（例如我們自己寫的中文 Exception），則允許直接顯示
    return errorKey;
  }
}   