// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_seen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider 管理「已看過」的票券 ID 集合
/// 使用 keepAlive: true 確保 App 運行期間保持狀態

@ProviderFor(VoucherSeenNotifier)
final voucherSeenProvider = VoucherSeenNotifierProvider._();

/// Provider 管理「已看過」的票券 ID 集合
/// 使用 keepAlive: true 確保 App 運行期間保持狀態
final class VoucherSeenNotifierProvider
    extends $NotifierProvider<VoucherSeenNotifier, Set<String>> {
  /// Provider 管理「已看過」的票券 ID 集合
  /// 使用 keepAlive: true 確保 App 運行期間保持狀態
  VoucherSeenNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voucherSeenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voucherSeenNotifierHash();

  @$internal
  @override
  VoucherSeenNotifier create() => VoucherSeenNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$voucherSeenNotifierHash() =>
    r'845b976167b6bb006cb3769ab9929fdd03032e01';

/// Provider 管理「已看過」的票券 ID 集合
/// 使用 keepAlive: true 確保 App 運行期間保持狀態

abstract class _$VoucherSeenNotifier extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider 計算未看過的可使用票券數量

@ProviderFor(unseenActiveVouchersCount)
final unseenActiveVouchersCountProvider = UnseenActiveVouchersCountProvider._();

/// Provider 計算未看過的可使用票券數量

final class UnseenActiveVouchersCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider 計算未看過的可使用票券數量
  UnseenActiveVouchersCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unseenActiveVouchersCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unseenActiveVouchersCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unseenActiveVouchersCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unseenActiveVouchersCountHash() =>
    r'66253fcfd14889d0cd9360f5cc75f0d5a3e68e35';
