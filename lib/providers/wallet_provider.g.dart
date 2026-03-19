// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WalletNotifier)
final walletProvider = WalletNotifierProvider._();

final class WalletNotifierProvider
    extends $NotifierProvider<WalletNotifier, WalletData?> {
  WalletNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletNotifierHash();

  @$internal
  @override
  WalletNotifier create() => WalletNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletData?>(value),
    );
  }
}

String _$walletNotifierHash() => r'd44cd0c328332ec4710f91b90d9714d6a0767e66';

abstract class _$WalletNotifier extends $Notifier<WalletData?> {
  WalletData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WalletData?, WalletData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WalletData?, WalletData?>,
              WalletData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
