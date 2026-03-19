import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'voucher_wallet_provider.dart';

part 'voucher_seen_provider.g.dart';

/// Provider 管理「已看過」的票券 ID 集合
/// 使用 keepAlive: true 確保 App 運行期間保持狀態
@Riverpod(keepAlive: true)
class VoucherSeenNotifier extends _$VoucherSeenNotifier {
  static const String _seenVouchersKey = 'seen_voucher_ids';

  @override
  Set<String> build() {
    // 初始時從 SharedPreferences 載入
    _loadSeenVouchers();
    return {};
  }

  /// 從 SharedPreferences 載入已看過的票券 ID
  Future<void> _loadSeenVouchers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_seenVouchersKey);
      if (jsonString != null) {
        final List<dynamic> ids = jsonDecode(jsonString);
        state = ids.map((e) => e.toString()).toSet();
      }
    } catch (e) {
      log('Error loading seen vouchers: $e');
    }
  }

  /// 標記票券為已看過
  Future<void> markAsSeen(String memberCouponId) async {
    if (state.contains(memberCouponId)) return;

    final newState = {...state, memberCouponId};
    state = newState;
    await _persistSeenVouchers();
  }

  /// 檢查票券是否未看過
  bool isUnseen(String memberCouponId) {
    return !state.contains(memberCouponId);
  }

  /// 清除所有「已看過」記錄（登出時呼叫）
  Future<void> clearSeenVouchers() async {
    state = {};
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_seenVouchersKey);
    } catch (e) {
      log('Error clearing seen vouchers: $e');
    }
  }

  /// 持久化到 SharedPreferences
  Future<void> _persistSeenVouchers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_seenVouchersKey, jsonEncode(state.toList()));
    } catch (e) {
      log('Error persisting seen vouchers: $e');
    }
  }
}

/// Provider 計算未看過的可使用票券數量
@riverpod
int unseenActiveVouchersCount(Ref ref) {
  final seenIds = ref.watch(voucherSeenProvider);
  final activeCouponsAsync = ref.watch(activeCouponsWithRulesProvider);

  return activeCouponsAsync.when(
    data: (coupons) => coupons
        .where((c) => !seenIds.contains(c.memberCoupon.memberCouponId))
        .length,
    loading: () => 0,
    error: (_, _) => 0,
  );
}
