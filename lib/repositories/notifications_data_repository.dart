import 'dart:async';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '/database/app_database.dart';
import '/models/notification_item_model.dart';
import '/models/notifications_response_model.dart';
import '/services/interface/i_notifications_data_service.dart';
import '/services/online/notifications_data_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/auth_provider.dart';
import '/providers/shared_preferences_provider.dart';
import '/services/interface/i_notification_service.dart';
import '/services/online/notification_service.dart';
import '/services/mock/notification_service_mock.dart';
import '/flavors.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'dart:io';
import 'package:drift/drift.dart';

class NotificationsDataRepository {
  final AppDatabase _db;
  final INotificationsDataService _notificationsService;
  final INotificationService _personalNotificationService;
  final Ref? _ref;

  static const String _notificationsEtagKey = 'notifications_etag';
  static const String _notificationsLastModifiedKey = 'notifications_last_modified';
  static const String _readStatusBackupKey = 'backup_read_notifications_v2';
  
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  NotificationsDataRepository({
    required AppDatabase db,
    INotificationsDataService? notificationsService,
    INotificationService? personalNotificationService,
    Ref? ref,
  })  : _db = db,
        _notificationsService = notificationsService ?? NotificationsDataService(),
        _personalNotificationService = personalNotificationService ??
            (F.useMockService
                ? NotificationServiceMock()
                : NotificationService()),
        _ref = ref {
    // Start reactive badge synchronization
    _initBadgeSync();
  }

  StreamSubscription? _badgeSubscription;

  void _initBadgeSync() {
    _badgeSubscription?.cancel();
    _badgeSubscription = watchUnreadCounts().listen((counts) {
      _updateBadgeCount(counts.total);
    });
  }

  Future<void> _updateBadgeCount(int count) async {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        final isSupported = await AppBadgePlus.isSupported();
        if (isSupported) {
          if (count > 0) {
            AppBadgePlus.updateBadge(count);
          } else {
            AppBadgePlus.updateBadge(0);
          }
           log('[NotificationsDataRepository] Application badge updated to: $count');
        }
      }
    } catch (e) {
      log('[NotificationsDataRepository] Error updating badge: $e');
    }
  }

  void dispose() {
    _badgeSubscription?.cancel();
  }
  // ========== Reactive Streams ==========

  /// Watch announcement notifications
  Stream<List<NotificationItemModel>> watchAnnouncementNotifications() {
    return _db.watchNotificationsByType(NotificationType.announcement);
  }

  /// Watch campaign notifications
  Stream<List<NotificationItemModel>> watchCampaignNotifications() {
    return _db.watchNotificationsByType(NotificationType.campaign);
  }

  /// Watch personal notifications
  Stream<List<NotificationItemModel>> watchPersonalNotifications() {
    return _db.watchPersonalNotifications();
  }

  /// Watch unread notification counts
  Stream<UnreadNotificationCounts> watchUnreadCounts() {
    return _db.watchUnreadNotificationCounts();
  }

  // ========== Badge Management ==========

  /// Clear the application badge (iOS/Android)
  Future<void> clearBadge() async {
    await _updateBadgeCount(0);
  }

  // ========== Read Status Management ==========

  /// Mark a single notification as read
  Future<void> markAsRead(String notificationId, NotificationType type) async {
    await _db.markNotificationAsRead(notificationId);
    log('[NotificationsDataRepository] Marked notification $notificationId ($type) as read');
    
    // Notify backend so it can reduce its counter (important for S3 source sync)
    try {
      await _personalNotificationService.reportReadStatus(
        id: notificationId,
        type: type.name.toUpperCase(),
      );
    } catch (e) {
      log('[NotificationsDataRepository] Failed to report read status to backend: $e');
    }
  }

  /// Insert personal notifications from FCM push
  Future<void> insertPersonalNotifications(List<NotificationItemModel> items) async {
    await _db.upsertNotifications(items, NotificationType.personal);
    log('[NotificationsDataRepository] Inserted ${items.length} personal notifications');
  }

  /// Mark all notifications of a specific type as read
  Future<void> markAllAsReadByType(NotificationType type) async {
    // 1. Get all unread IDs of this type before marking
    final now = DateTime.now().toUtc();
    final typeString = type.name.toUpperCase();
    final unreadEntities = await (_db.select(_db.notifications)..where((n) => n.notificationType.equals(typeString) & n.isRead.equals(false))).get();
    
    // Applying date filters if needed (Drift logic)
    var entitiesToReport = unreadEntities;
    if (type != NotificationType.personal) {
        entitiesToReport = unreadEntities.where((n) {
          final isStarted = n.publishedAt.isBefore(now) || n.publishedAt.isAtSameMomentAs(now);
          final isNotExpired = n.expiredAt == null || n.expiredAt!.isAfter(now);
          return isStarted && isNotExpired;
        }).toList();
    }
    
    // 2. Mark locally
    await _db.markAllNotificationsAsReadByType(type);
    log('[NotificationsDataRepository] Marked all ${type.name} notifications as read locally');
    
    // 3. Report to backend for each valid entity
    for (final entity in entitiesToReport) {
      try {
        await _personalNotificationService.reportReadStatus(
          id: entity.id,
          type: type.name.toUpperCase(),
        );
      } catch (e) {
        log('[NotificationsDataRepository] Failed to report bulk read status for ${entity.id}: $e');
      }
    }
  }

  // ========== Synchronization ==========

  /// Sync notifications from S3 (upsert + cleanup + conditional request)
  Future<void> syncNotifications({bool forceRefresh = false}) async {
    try {
      final cachedAt = await _db.getLatestNotificationCachedAt();

      if (!forceRefresh && cachedAt != null && _isCacheValid(cachedAt)) {
        log('[NotificationsDataRepository] Cache is valid, skipping sync');
        return;
      }

      final prefs = _ref?.read(sharedPreferencesProvider);
      if (prefs == null) {
        log('[NotificationsDataRepository] No ref or prefs available, skipping sync');
        return;
      }
      final etag = prefs.getString(_notificationsEtagKey);
      final lastModified = prefs.getString(_notificationsLastModifiedKey);

      try {
        final response = await _notificationsService.fetchNotifications(
          etag: etag,
          lastModified: lastModified,
        );

        log('[NotificationsDataRepository] Fetched ${response.announcements.length} announcements, ${response.campaigns.length} campaigns from S3');

        // Upsert announcements
        await _db.upsertNotifications(response.announcements, NotificationType.announcement);
        // Delete announcements not in response
        final announcementIds = response.announcements.map((n) => n.id).toList();
        await _db.deleteNotificationsNotInList(announcementIds, NotificationType.announcement);

        // Upsert campaigns
        await _db.upsertNotifications(response.campaigns, NotificationType.campaign);
        // Delete campaigns not in response
        final campaignIds = response.campaigns.map((n) => n.id).toList();
        await _db.deleteNotificationsNotInList(campaignIds, NotificationType.campaign);

        // Save new ETag and Last-Modified headers
        if (response.etag != null) {
          await prefs.setString(_notificationsEtagKey, response.etag!);
        }
        if (response.lastModified != null) {
          await prefs.setString(_notificationsLastModifiedKey, response.lastModified!);
        }

        // --- Fetch Personal Notifications ---
        final authData = _ref?.read(authProvider);
        if (authData != null && authData.accessToken.isNotEmpty) {
          log('[NotificationsDataRepository] User authenticated, fetching personal notifications history from API');
          try {
            final personalItems = await _personalNotificationService.getPersonalNotifications();
            log('[NotificationsDataRepository] Fetched ${personalItems.length} personal notifications from API');
            await _db.upsertNotifications(personalItems, NotificationType.personal);
          } catch (e) {
            log('[NotificationsDataRepository] Failed to fetch personal notifications: $e');
          }
        }

        // --- Restore Read Status from Backup if needed ---
        final backupReadIds = prefs.getStringList(_readStatusBackupKey);
        if (backupReadIds != null && backupReadIds.isNotEmpty) {
          log('[NotificationsDataRepository] Restoring ${backupReadIds.length} read notifications from backup');
          for (final id in backupReadIds) {
            await _db.markNotificationAsRead(id);
          }
           // Clear backup after successful restore
          await prefs.remove(_readStatusBackupKey);
        }

        log('[NotificationsDataRepository] Synced notifications successfully');
      } on NotificationsCacheNotModifiedException {
        log('[NotificationsDataRepository] Notifications not modified (304), using existing database data');
      }
    } catch (e) {
      log('[NotificationsDataRepository] Error syncing notifications: $e');

      // Fallback: Load bundled assets if database is empty
      final existingAnnouncements = await _db.watchNotificationsByType(NotificationType.announcement).first;
      if (existingAnnouncements.isEmpty) {
        log('[NotificationsDataRepository] Database empty, loading bundled notifications');
        try {
          final bundledData = await _notificationsService.loadBundledNotifications();
          await _db.upsertNotifications(bundledData.announcements, NotificationType.announcement);
          await _db.upsertNotifications(bundledData.campaigns, NotificationType.campaign);
          log('[NotificationsDataRepository] Loaded bundled notifications into database');
        } catch (e2) {
          log('[NotificationsDataRepository] Failed to load bundled notifications: $e2');
        }
      }
    }
  }

  // ========== Utility Methods ==========

  /// Check if cache is still valid
  bool _isCacheValid(DateTime cachedAt) {
    final age = DateTime.now().difference(cachedAt);
    return age < _cacheValidityDuration;
  }

  /// Clear all notifications data (for logout)
  Future<void> clearAll() async {
    await _db.clearAllNotifications();
    log('[NotificationsDataRepository] Cleared all notifications');
  }

  /// Clear cache (Deep Clean)
  /// Wipes database table but backs up read status first
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Backup Read Status
      final readIds = await _db.getReadNotificationIds();
      if (readIds.isNotEmpty) {
        await prefs.setStringList(_readStatusBackupKey, readIds);
         log('[NotificationsDataRepository] Backed up ${readIds.length} read notifications');
      }

      // 2. Clear Headers
      await prefs.remove(_notificationsEtagKey);
      await prefs.remove(_notificationsLastModifiedKey);
      
      // 3. Deep Clean DB
      await _db.clearAllNotifications();
      
      log('[NotificationsDataRepository] Cleared all notifications cache (Deep Clean)');
    } catch (e) {
      log('[NotificationsDataRepository] Error clearing cache: $e');
    }
  }
}
