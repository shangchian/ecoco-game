import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/services/deep_link/deep_link_data.dart';

part 'pending_deep_link_provider.g.dart';

/// 儲存未登入時收到的 deep link，登入後執行
@riverpod
class PendingDeepLink extends _$PendingDeepLink {
  @override
  DeepLinkData? build() => null;

  void set(DeepLinkData? data) {
    state = data;
  }

  void clear() {
    state = null;
  }
}
