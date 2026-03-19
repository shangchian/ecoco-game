// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the appropriate Notification Service based on the current flavor
/// - Mock builds: Uses NotificationServiceMock for testing
/// - Internal/Production builds: Uses real NotificationService with token hooks

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

/// Provides the appropriate Notification Service based on the current flavor
/// - Mock builds: Uses NotificationServiceMock for testing
/// - Internal/Production builds: Uses real NotificationService with token hooks

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          INotificationService,
          INotificationService,
          INotificationService
        >
    with $Provider<INotificationService> {
  /// Provides the appropriate Notification Service based on the current flavor
  /// - Mock builds: Uses NotificationServiceMock for testing
  /// - Internal/Production builds: Uses real NotificationService with token hooks
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<INotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  INotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'1b6657b2aff8e2f9900e3fef24242d2f4e0fe7dc';
