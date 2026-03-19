// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_district_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for area/district data loaded from S3 cache
/// Returns data in legacy Area model format for backward compatibility

@ProviderFor(AreaDistrictNotifier)
final areaDistrictProvider = AreaDistrictNotifierProvider._();

/// Provider for area/district data loaded from S3 cache
/// Returns data in legacy Area model format for backward compatibility
final class AreaDistrictNotifierProvider
    extends $NotifierProvider<AreaDistrictNotifier, Area> {
  /// Provider for area/district data loaded from S3 cache
  /// Returns data in legacy Area model format for backward compatibility
  AreaDistrictNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areaDistrictProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areaDistrictNotifierHash();

  @$internal
  @override
  AreaDistrictNotifier create() => AreaDistrictNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Area value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Area>(value),
    );
  }
}

String _$areaDistrictNotifierHash() =>
    r'1b2eee9c42e64110ff1804d3ee123b10bd35ff46';

/// Provider for area/district data loaded from S3 cache
/// Returns data in legacy Area model format for backward compatibility

abstract class _$AreaDistrictNotifier extends $Notifier<Area> {
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
