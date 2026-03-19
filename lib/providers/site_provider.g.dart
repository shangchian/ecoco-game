// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Sites)
final sitesProvider = SitesProvider._();

final class SitesProvider extends $StreamNotifierProvider<Sites, List<Site>> {
  SitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sitesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sitesHash();

  @$internal
  @override
  Sites create() => Sites();
}

String _$sitesHash() => r'e2691bd64db288992592be0d25f53df88ef6a15d';

abstract class _$Sites extends $StreamNotifier<List<Site>> {
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
