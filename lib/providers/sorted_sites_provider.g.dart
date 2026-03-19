// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorted_sites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FrozenFavoriteCodes)
final frozenFavoriteCodesProvider = FrozenFavoriteCodesProvider._();

final class FrozenFavoriteCodesProvider
    extends $NotifierProvider<FrozenFavoriteCodes, Set<String>?> {
  FrozenFavoriteCodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frozenFavoriteCodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frozenFavoriteCodesHash();

  @$internal
  @override
  FrozenFavoriteCodes create() => FrozenFavoriteCodes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>?>(value),
    );
  }
}

String _$frozenFavoriteCodesHash() =>
    r'32c6f13b8c6cd61cf6eb0c781516fe3b58ca4dac';

abstract class _$FrozenFavoriteCodes extends $Notifier<Set<String>?> {
  Set<String>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>?, Set<String>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>?, Set<String>?>,
              Set<String>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SortedSites)
final sortedSitesProvider = SortedSitesProvider._();

final class SortedSitesProvider
    extends $StreamNotifierProvider<SortedSites, List<Site>> {
  SortedSitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortedSitesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortedSitesHash();

  @$internal
  @override
  SortedSites create() => SortedSites();
}

String _$sortedSitesHash() => r'5f9f31de482dcc8b64dc19a1777559be8877f53a';

abstract class _$SortedSites extends $StreamNotifier<List<Site>> {
  Stream<List<Site>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Site>>, List<Site>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Site>>, List<Site>>,
              AsyncValue<List<Site>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
