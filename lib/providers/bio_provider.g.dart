// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Bio)
final bioProvider = BioProvider._();

final class BioProvider extends $NotifierProvider<Bio, void> {
  BioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bioHash();

  @$internal
  @override
  Bio create() => Bio();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$bioHash() => r'c4287c4a16e593991222ab57345263afc2b6feeb';

abstract class _$Bio extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
