// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppModeState)
final appModeStateProvider = AppModeStateProvider._();

final class AppModeStateProvider
    extends $NotifierProvider<AppModeState, AppMode> {
  AppModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appModeStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appModeStateHash();

  @$internal
  @override
  AppModeState create() => AppModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppMode>(value),
    );
  }
}

String _$appModeStateHash() => r'f5eac4de7801becfecca1330cd160416bc8baade';

abstract class _$AppModeState extends $Notifier<AppMode> {
  AppMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppMode, AppMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppMode, AppMode>,
              AppMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
