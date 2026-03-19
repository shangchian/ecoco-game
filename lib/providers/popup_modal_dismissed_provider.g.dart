// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popup_modal_dismissed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider 管理「今日不再顯示」彈窗狀態
/// 使用 SharedPreferences 儲存今日是否已勾選不再顯示

@ProviderFor(PopupModalDismissed)
final popupModalDismissedProvider = PopupModalDismissedProvider._();

/// Provider 管理「今日不再顯示」彈窗狀態
/// 使用 SharedPreferences 儲存今日是否已勾選不再顯示
final class PopupModalDismissedProvider
    extends $AsyncNotifierProvider<PopupModalDismissed, bool> {
  /// Provider 管理「今日不再顯示」彈窗狀態
  /// 使用 SharedPreferences 儲存今日是否已勾選不再顯示
  PopupModalDismissedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popupModalDismissedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popupModalDismissedHash();

  @$internal
  @override
  PopupModalDismissed create() => PopupModalDismissed();
}

String _$popupModalDismissedHash() =>
    r'6a6d1f69204ef6539dbbbaf6fec63bf0128dd286';

/// Provider 管理「今日不再顯示」彈窗狀態
/// 使用 SharedPreferences 儲存今日是否已勾選不再顯示

abstract class _$PopupModalDismissed extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
