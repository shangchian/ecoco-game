// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycling_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecyclingStats)
final recyclingStatsProvider = RecyclingStatsProvider._();

final class RecyclingStatsProvider
    extends $NotifierProvider<RecyclingStats, RecyclingStatsData?> {
  RecyclingStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recyclingStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recyclingStatsHash();

  @$internal
  @override
  RecyclingStats create() => RecyclingStats();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecyclingStatsData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecyclingStatsData?>(value),
    );
  }
}

String _$recyclingStatsHash() => r'a6d7ac308f12fa7bc6ea83c8aea0dffd027b6325';

abstract class _$RecyclingStats extends $Notifier<RecyclingStatsData?> {
  RecyclingStatsData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RecyclingStatsData?, RecyclingStatsData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecyclingStatsData?, RecyclingStatsData?>,
              RecyclingStatsData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
