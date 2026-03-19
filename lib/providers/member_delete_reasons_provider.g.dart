// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_delete_reasons_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MemberDeleteReasons)
final memberDeleteReasonsProvider = MemberDeleteReasonsProvider._();

final class MemberDeleteReasonsProvider
    extends $NotifierProvider<MemberDeleteReasons, DeleteReasonsResponse?> {
  MemberDeleteReasonsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberDeleteReasonsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberDeleteReasonsHash();

  @$internal
  @override
  MemberDeleteReasons create() => MemberDeleteReasons();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteReasonsResponse? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteReasonsResponse?>(value),
    );
  }
}

String _$memberDeleteReasonsHash() =>
    r'8a5e789aff3cf0c6059914901014f9e579c3cc12';

abstract class _$MemberDeleteReasons extends $Notifier<DeleteReasonsResponse?> {
  DeleteReasonsResponse? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<DeleteReasonsResponse?, DeleteReasonsResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeleteReasonsResponse?, DeleteReasonsResponse?>,
              DeleteReasonsResponse?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
