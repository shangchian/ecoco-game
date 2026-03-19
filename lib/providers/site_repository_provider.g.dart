// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(siteRepository)
final siteRepositoryProvider = SiteRepositoryProvider._();

final class SiteRepositoryProvider
    extends $FunctionalProvider<SiteRepository, SiteRepository, SiteRepository>
    with $Provider<SiteRepository> {
  SiteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'siteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$siteRepositoryHash();

  @$internal
  @override
  $ProviderElement<SiteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SiteRepository create(Ref ref) {
    return siteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiteRepository>(value),
    );
  }
}

String _$siteRepositoryHash() => r'e3638e05cd1715478223279ed2f7c725ceb26f17';
