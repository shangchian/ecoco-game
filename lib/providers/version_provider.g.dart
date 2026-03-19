// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VersionNotifier)
final versionProvider = VersionNotifierProvider._();

final class VersionNotifierProvider
    extends $NotifierProvider<VersionNotifier, VersionData> {
  VersionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionNotifierHash();

  @$internal
  @override
  VersionNotifier create() => VersionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionData>(value),
    );
  }
}

String _$versionNotifierHash() => r'c02c7ea7715b1edbbd1494c5c5fea251d3c61728';

abstract class _$VersionNotifier extends $Notifier<VersionData> {
  VersionData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VersionData, VersionData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VersionData, VersionData>,
              VersionData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
