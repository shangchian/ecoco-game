// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileNotifier)
final profileProvider = ProfileNotifierProvider._();

final class ProfileNotifierProvider
    extends $NotifierProvider<ProfileNotifier, ProfileData?> {
  ProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileNotifierHash();

  @$internal
  @override
  ProfileNotifier create() => ProfileNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileData?>(value),
    );
  }
}

String _$profileNotifierHash() => r'916bf31411b9d31cafdc7b700b5cdda43a005a62';

abstract class _$ProfileNotifier extends $Notifier<ProfileData?> {
  ProfileData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProfileData?, ProfileData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileData?, ProfileData?>,
              ProfileData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
