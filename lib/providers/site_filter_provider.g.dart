// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SiteFilterNotifier)
final siteFilterProvider = SiteFilterNotifierProvider._();

final class SiteFilterNotifierProvider
    extends $NotifierProvider<SiteFilterNotifier, SiteFilter> {
  SiteFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'siteFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$siteFilterNotifierHash();

  @$internal
  @override
  SiteFilterNotifier create() => SiteFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiteFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiteFilter>(value),
    );
  }
}

String _$siteFilterNotifierHash() =>
    r'88cc576b323f1d02c1c33a0c0d1f34e17215f943';

abstract class _$SiteFilterNotifier extends $Notifier<SiteFilter> {
  SiteFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SiteFilter, SiteFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SiteFilter, SiteFilter>,
              SiteFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
