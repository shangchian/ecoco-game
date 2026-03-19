// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AvatarNotifier)
final avatarProvider = AvatarNotifierProvider._();

final class AvatarNotifierProvider
    extends $NotifierProvider<AvatarNotifier, AvatarState> {
  AvatarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarNotifierHash();

  @$internal
  @override
  AvatarNotifier create() => AvatarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarState>(value),
    );
  }
}

String _$avatarNotifierHash() => r'effdc93c0371d9ee9942fb7ee6a1882fcfa4a51b';

abstract class _$AvatarNotifier extends $Notifier<AvatarState> {
  AvatarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AvatarState, AvatarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AvatarState, AvatarState>,
              AvatarState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
