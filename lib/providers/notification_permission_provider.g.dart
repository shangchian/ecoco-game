// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_permission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationPermission)
final notificationPermissionProvider = NotificationPermissionProvider._();

final class NotificationPermissionProvider
    extends
        $NotifierProvider<NotificationPermission, NotificationPermissionState> {
  NotificationPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionHash();

  @$internal
  @override
  NotificationPermission create() => NotificationPermission();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationPermissionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationPermissionState>(value),
    );
  }
}

String _$notificationPermissionHash() =>
    r'91b8ef6c0c8e377c7480eebf085fdc44fafd27a2';

abstract class _$NotificationPermission
    extends $Notifier<NotificationPermissionState> {
  NotificationPermissionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<NotificationPermissionState, NotificationPermissionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                NotificationPermissionState,
                NotificationPermissionState
              >,
              NotificationPermissionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
