// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForgetPasswordController)
final forgetPasswordControllerProvider = ForgetPasswordControllerProvider._();

final class ForgetPasswordControllerProvider
    extends $NotifierProvider<ForgetPasswordController, ForgetPasswordState> {
  ForgetPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgetPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgetPasswordControllerHash();

  @$internal
  @override
  ForgetPasswordController create() => ForgetPasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForgetPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForgetPasswordState>(value),
    );
  }
}

String _$forgetPasswordControllerHash() =>
    r'3c2e817d65e07123741e2fce61739cd8ac3b2b89';

abstract class _$ForgetPasswordController
    extends $Notifier<ForgetPasswordState> {
  ForgetPasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ForgetPasswordState, ForgetPasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ForgetPasswordState, ForgetPasswordState>,
              ForgetPasswordState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
