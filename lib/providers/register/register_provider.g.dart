// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterNotifier)
final registerProvider = RegisterNotifierProvider._();

final class RegisterNotifierProvider
    extends $NotifierProvider<RegisterNotifier, RegisterState> {
  RegisterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerNotifierHash();

  @$internal
  @override
  RegisterNotifier create() => RegisterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterState>(value),
    );
  }
}

String _$registerNotifierHash() => r'7b1a2a9120cf3887ab2fe4decb19fb74ee70a84c';

abstract class _$RegisterNotifier extends $Notifier<RegisterState> {
  RegisterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RegisterState, RegisterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RegisterState, RegisterState>,
              RegisterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
