// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pointsRepository)
final pointsRepositoryProvider = PointsRepositoryProvider._();

final class PointsRepositoryProvider
    extends
        $FunctionalProvider<
          PointsRepository,
          PointsRepository,
          PointsRepository
        >
    with $Provider<PointsRepository> {
  PointsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PointsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PointsRepository create(Ref ref) {
    return pointsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PointsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PointsRepository>(value),
    );
  }
}

String _$pointsRepositoryHash() => r'd75db1542158997e00170544a371d09aed480d9c';
