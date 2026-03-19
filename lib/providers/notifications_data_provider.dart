import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/notification_item_model.dart';
import '/models/notifications_response_model.dart';
import '/repositories/notifications_data_repository.dart';
import '/providers/app_database_provider.dart';
import '/providers/notifications_data_service_provider.dart';

part 'notifications_data_provider.g.dart';

/// Notifications data repository provider
@Riverpod(keepAlive: true)
NotificationsDataRepository notificationsDataRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final notificationsService = ref.watch(notificationsDataServiceProvider);
  return NotificationsDataRepository(
    db: db,
    notificationsService: notificationsService,
    ref: ref,
  );
}

/// Watch announcement notifications with background sync
@Riverpod(keepAlive: true)
class AnnouncementNotifications extends _$AnnouncementNotifications {
  @override
  Stream<List<NotificationItemModel>> build() {
    final repository = ref.watch(notificationsDataRepositoryProvider);
    _initSync();
    return repository.watchAnnouncementNotifications();
  }

  Future<void> _initSync() async {
    try {
      final repository = ref.read(notificationsDataRepositoryProvider);
      await repository.syncNotifications();
    } catch (e) {
      // Log error but don't block UI
    }
  }

  Future<void> refresh() async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.syncNotifications(forceRefresh: true);
  }

  Future<void> markAsRead(String notificationId) async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.markAsRead(notificationId, NotificationType.announcement);
  }

  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.markAllAsReadByType(NotificationType.announcement);
  }
}

/// Watch campaign notifications with background sync
@Riverpod(keepAlive: true)
class CampaignNotifications extends _$CampaignNotifications {
  @override
  Stream<List<NotificationItemModel>> build() {
    final repository = ref.watch(notificationsDataRepositoryProvider);
    return repository.watchCampaignNotifications();
  }

  Future<void> refresh() async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.syncNotifications(forceRefresh: true);
  }

  Future<void> markAsRead(String notificationId) async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.markAsRead(notificationId, NotificationType.campaign);
  }

  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.markAllAsReadByType(NotificationType.campaign);
  }
}

/// Watch personal notifications (No background sync since FCM handles it directly)
@Riverpod(keepAlive: true)
class PersonalNotifications extends _$PersonalNotifications {
  @override
  Stream<List<NotificationItemModel>> build() {
    final repository = ref.watch(notificationsDataRepositoryProvider);
    return repository.watchPersonalNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.markAsRead(notificationId, NotificationType.personal);
  }

  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationsDataRepositoryProvider);
    await repository.markAllAsReadByType(NotificationType.personal);
  }
}

/// Watch unread notification counts
@Riverpod(keepAlive: true)
Stream<UnreadNotificationCounts> unreadNotificationCounts(Ref ref) {
  final repository = ref.watch(notificationsDataRepositoryProvider);
  return repository.watchUnreadCounts();
}
