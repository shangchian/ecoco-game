// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Points history provider with state management

@ProviderFor(PointsHistoryNotifier)
final pointsHistoryProvider = PointsHistoryNotifierProvider._();

/// Points history provider with state management
final class PointsHistoryNotifierProvider
    extends $NotifierProvider<PointsHistoryNotifier, PointsHistoryState> {
  /// Points history provider with state management
  PointsHistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointsHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointsHistoryNotifierHash();

  @$internal
  @override
  PointsHistoryNotifier create() => PointsHistoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PointsHistoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PointsHistoryState>(value),
    );
  }
}

String _$pointsHistoryNotifierHash() =>
    r'e162b5ce260a4bcd5b0f30b225618efa3aca9d78';

/// Points history provider with state management

abstract class _$PointsHistoryNotifier extends $Notifier<PointsHistoryState> {
  PointsHistoryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PointsHistoryState, PointsHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PointsHistoryState, PointsHistoryState>,
              PointsHistoryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
