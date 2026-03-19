// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_sites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FavoriteSites)
final favoriteSitesProvider = FavoriteSitesProvider._();

final class FavoriteSitesProvider
    extends $StreamNotifierProvider<FavoriteSites, List<Site>> {
  FavoriteSitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteSitesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteSitesHash();

  @$internal
  @override
  FavoriteSites create() => FavoriteSites();
}

String _$favoriteSitesHash() => r'977851253335a524f49dea18e07cc59884b6e3b5';

abstract class _$FavoriteSites extends $StreamNotifier<List<Site>> {
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
