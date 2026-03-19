// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_data_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsDataService)
final notificationsDataServiceProvider = NotificationsDataServiceProvider._();

final class NotificationsDataServiceProvider
    extends
        $FunctionalProvider<
          INotificationsDataService,
          INotificationsDataService,
          INotificationsDataService
        >
    with $Provider<INotificationsDataService> {
  NotificationsDataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsDataServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsDataServiceHash();

  @$internal
  @override
  $ProviderElement<INotificationsDataService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  INotificationsDataService create(Ref ref) {
    return notificationsDataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotificationsDataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotificationsDataService>(value),
    );
  }
}

String _$notificationsDataServiceHash() =>
    r'839a0aee727ac57dbde207a310047ae78d542856';
