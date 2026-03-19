// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_deep_link_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 儲存未登入時收到的 deep link，登入後執行

@ProviderFor(PendingDeepLink)
final pendingDeepLinkProvider = PendingDeepLinkProvider._();

/// 儲存未登入時收到的 deep link，登入後執行
final class PendingDeepLinkProvider
    extends $NotifierProvider<PendingDeepLink, DeepLinkData?> {
  /// 儲存未登入時收到的 deep link，登入後執行
  PendingDeepLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingDeepLinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingDeepLinkHash();

  @$internal
  @override
  PendingDeepLink create() => PendingDeepLink();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkData?>(value),
    );
  }
}

String _$pendingDeepLinkHash() => r'3f8c12401971890988ab515e29aac77095b48b05';

/// 儲存未登入時收到的 deep link，登入後執行

abstract class _$PendingDeepLink extends $Notifier<DeepLinkData?> {
  DeepLinkData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DeepLinkData?, DeepLinkData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeepLinkData?, DeepLinkData?>,
              DeepLinkData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
