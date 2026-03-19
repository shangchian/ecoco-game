// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameWallet)
final gameWalletProvider = GameWalletProvider._();

final class GameWalletProvider
    extends $StreamNotifierProvider<GameWallet, GameWalletModel> {
  GameWalletProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameWalletProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameWalletHash();

  @$internal
  @override
  GameWallet create() => GameWallet();
}

String _$gameWalletHash() => r'00a4c92b9684231299ee1bf3b25ea291c2480360';

abstract class _$GameWallet extends $StreamNotifier<GameWalletModel> {
  Stream<GameWalletModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GameWalletModel>, GameWalletModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GameWalletModel>, GameWalletModel>,
              AsyncValue<GameWalletModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
