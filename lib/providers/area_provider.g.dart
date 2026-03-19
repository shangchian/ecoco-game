// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AreaNotifier)
final areaProvider = AreaNotifierProvider._();

final class AreaNotifierProvider extends $NotifierProvider<AreaNotifier, Area> {
  AreaNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areaProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areaNotifierHash();

  @$internal
  @override
  AreaNotifier create() => AreaNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Area value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Area>(value),
    );
  }
}

String _$areaNotifierHash() => r'ef8437a20898a8646564826fa24a55849049d888';

abstract class _$AreaNotifier extends $Notifier<Area> {
  Area build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Area, Area>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Area, Area>,
              Area,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
