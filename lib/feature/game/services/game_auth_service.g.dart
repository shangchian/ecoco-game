// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameAuthService)
final gameAuthServiceProvider = GameAuthServiceProvider._();

final class GameAuthServiceProvider
    extends $NotifierProvider<GameAuthService, void> {
  GameAuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameAuthServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameAuthServiceHash();

  @$internal
  @override
  GameAuthService create() => GameAuthService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$gameAuthServiceHash() => r'6b858e7d3b27546a012c4b11600588fb4cfd6050';

abstract class _$GameAuthService extends $Notifier<void> {
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
