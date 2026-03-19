// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifications data repository provider

@ProviderFor(notificationsDataRepository)
final notificationsDataRepositoryProvider =
    NotificationsDataRepositoryProvider._();

/// Notifications data repository provider

final class NotificationsDataRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationsDataRepository,
          NotificationsDataRepository,
          NotificationsDataRepository
        >
    with $Provider<NotificationsDataRepository> {
  /// Notifications data repository provider
  NotificationsDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsDataRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationsDataRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationsDataRepository create(Ref ref) {
    return notificationsDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsDataRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsDataRepository>(value),
    );
  }
}

String _$notificationsDataRepositoryHash() =>
    r'd092f7e07095ac8dd686a217a3c98682d1172ba8';

/// Watch announcement notifications with background sync

@ProviderFor(AnnouncementNotifications)
final announcementNotificationsProvider = AnnouncementNotificationsProvider._();

/// Watch announcement notifications with background sync
final class AnnouncementNotificationsProvider
    extends
        $StreamNotifierProvider<
          AnnouncementNotifications,
          List<NotificationItemModel>
        > {
  /// Watch announcement notifications with background sync
  AnnouncementNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementNotificationsHash();

  @$internal
  @override
  AnnouncementNotifications create() => AnnouncementNotifications();
}

String _$announcementNotificationsHash() =>
    r'3da059c19ffc6b32cdb35350127348a65845694d';

/// Watch announcement notifications with background sync

abstract class _$AnnouncementNotifications
    extends $StreamNotifier<List<NotificationItemModel>> {
  Stream<List<NotificationItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationItemModel>>,
              List<NotificationItemModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationItemModel>>,
                List<NotificationItemModel>
              >,
              AsyncValue<List<NotificationItemModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Watch campaign notifications with background sync

@ProviderFor(CampaignNotifications)
final campaignNotificationsProvider = CampaignNotificationsProvider._();

/// Watch campaign notifications with background sync
final class CampaignNotificationsProvider
    extends
        $StreamNotifierProvider<
          CampaignNotifications,
          List<NotificationItemModel>
        > {
  /// Watch campaign notifications with background sync
  CampaignNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'campaignNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$campaignNotificationsHash();

  @$internal
  @override
  CampaignNotifications create() => CampaignNotifications();
}

String _$campaignNotificationsHash() =>
    r'621a2224eec955c2cb9caf71257f2b485e7939e8';

/// Watch campaign notifications with background sync

abstract class _$CampaignNotifications
    extends $StreamNotifier<List<NotificationItemModel>> {
  Stream<List<NotificationItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationItemModel>>,
              List<NotificationItemModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationItemModel>>,
                List<NotificationItemModel>
              >,
              AsyncValue<List<NotificationItemModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Watch personal notifications (No background sync since FCM handles it directly)

@ProviderFor(PersonalNotifications)
final personalNotificationsProvider = PersonalNotificationsProvider._();

/// Watch personal notifications (No background sync since FCM handles it directly)
final class PersonalNotificationsProvider
    extends
        $StreamNotifierProvider<
          PersonalNotifications,
          List<NotificationItemModel>
        > {
  /// Watch personal notifications (No background sync since FCM handles it directly)
  PersonalNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalNotificationsHash();

  @$internal
  @override
  PersonalNotifications create() => PersonalNotifications();
}

String _$personalNotificationsHash() =>
    r'cb2422597d1851db449c6a25fad7f26cb0581dc7';

/// Watch personal notifications (No background sync since FCM handles it directly)

abstract class _$PersonalNotifications
    extends $StreamNotifier<List<NotificationItemModel>> {
  Stream<List<NotificationItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationItemModel>>,
              List<NotificationItemModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationItemModel>>,
                List<NotificationItemModel>
              >,
              AsyncValue<List<NotificationItemModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Watch unread notification counts

@ProviderFor(unreadNotificationCounts)
final unreadNotificationCountsProvider = UnreadNotificationCountsProvider._();

/// Watch unread notification counts

final class UnreadNotificationCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UnreadNotificationCounts>,
          UnreadNotificationCounts,
          Stream<UnreadNotificationCounts>
        >
    with
        $FutureModifier<UnreadNotificationCounts>,
        $StreamProvider<UnreadNotificationCounts> {
  /// Watch unread notification counts
  UnreadNotificationCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountsHash();

  @$internal
  @override
  $StreamProviderElement<UnreadNotificationCounts> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UnreadNotificationCounts> create(Ref ref) {
    return unreadNotificationCounts(ref);
  }
}

String _$unreadNotificationCountsHash() =>
    r'2bb5e77d9905faa09d000f05354f0c3057e20eea';
