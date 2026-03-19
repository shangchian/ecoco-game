// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IAPManager)
final iAPManagerProvider = IAPManagerProvider._();

final class IAPManagerProvider
    extends $NotifierProvider<IAPManager, List<ShopProductModel>> {
  IAPManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iAPManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iAPManagerHash();

  @$internal
  @override
  IAPManager create() => IAPManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ShopProductModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ShopProductModel>>(value),
    );
  }
}

String _$iAPManagerHash() => r'd8f796ac4fe9f372158db21ca3e5a7e56baf01ea';

abstract class _$IAPManager extends $Notifier<List<ShopProductModel>> {
  List<ShopProductModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<ShopProductModel>, List<ShopProductModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ShopProductModel>, List<ShopProductModel>>,
              List<ShopProductModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
