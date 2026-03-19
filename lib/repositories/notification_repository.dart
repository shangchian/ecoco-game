import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import '/flavors.dart';
import '/models/auth_data_model.dart';
import '/models/notification_preferences.dart';
import '/models/notification_settings_model.dart' as app_models;
import '/providers/auth_provider.dart';
import '/services/firebase_messaging_service.dart';
import '/services/interface/i_notification_service.dart';
import '/services/interface/i_members_service.dart';
import '/services/mock/notification_service_mock.dart';
import '/services/mock/members_service_mock.dart';
import '../services/online/notification_service.dart';
import '../services/online/members_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/storage_service.dart';
import '/utils/device_info_helper.dart';

enum NotificationErrorCode {
  serverError,
  networkError,
  permissionDenied,
  unknown,
}

class NotificationException implements Exception {
  final NotificationErrorCode code;
  final String message;

  NotificationException(this.code, this.message);

  @override
  String toString() => message;
}

class NotificationRepository {
  static const String notificationDataKey = 'notificationData';
  static const String fcmTokenKey = 'fcmToken';
  static const String lastPermissionRequestKey = 'lastPermissionRequest';
  static const int permissionRequestInterval = 90;

  final INotificationService _notificationService;
  final IMembersService _membersService;
  final StorageService _storageService;
  final Ref? _ref;

  // Dirty flag tracking for retry mechanism
  bool _hasPendingChanges = false;
  NotificationPreferences? _pendingPreferences;
  bool? _pendingGlobalStatus;

  NotificationRepository({
    INotificationService? notificationService,
    IMembersService? membersService,
    StorageService? storageService,
    Ref? ref,
  })  : _notificationService = notificationService ??
            (F.useMockService
                ? NotificationServiceMock()
                : NotificationService()),
        _membersService = membersService ??
            (F.useMockService
                ? MembersServiceMock()
                : MembersService()),
        _storageService = storageService ?? StorageService(),
        _ref = ref;

  // Initialize notification system on app startup
  Future<void> init(AuthData? authData) async {
    try {
      // FirebaseMessagingService.init() is now called globally in main.dart
      // Setup FCM token refresh listener
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        if (_ref != null) {
          final realtimeAuthData = _ref.read(authProvider);
          if (realtimeAuthData != null) {
            _handleTokenRefresh(realtimeAuthData, fcmToken);
          }
        }
      }).onError((err) => _handleError('Token refresh error', err));
    } catch (e) {
      _handleError('Initialization error', e);
    }
  }

  Future<void> _handleTokenRefresh(AuthData authData, String fcmToken) async {
    try {
      // Update FCM token on member profile
      final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
      await _membersService.updateFcmToken(
        fcmToken: fcmToken,
        deviceId: deviceInfo['deviceId']!,
        platform: deviceInfo['platform']!,
        deviceModel: deviceInfo['deviceModel']!,
        osVersion: deviceInfo['osVersion']!,
      );
      log('FCM token updated on server successfully');
    } catch (e) {
      log('Failed to update FCM token on server: $e');
    }
  }

  // Request notification permissions and setup
  // provisional: true for app startup (iOS silent, Android 90-day throttle)
  // forceAsk: true to open system settings
  Future<bool> setupNotifications({bool provisional = false, bool forceAsk = false}) async {
    try {
      // Mock mode: skip OS permissions and Firebase calls
      if (F.useMockService) {
        await _storageService.saveMockNotificationEnabled(true);
        return true;
      }

      bool isEnabled = false;
      if (Platform.isAndroid && provisional) {
        // Android: request permission every 90 days if not granted
        final prefs = await SharedPreferences.getInstance();
        final lastRequest = prefs.getInt(lastPermissionRequestKey);
        if (lastRequest != null) {
          final lastRequestDate =
              DateTime.fromMillisecondsSinceEpoch(lastRequest);
          final now = DateTime.now();
          if (now.difference(lastRequestDate).inDays <
              permissionRequestInterval) {
            isEnabled = false;
          } else {
            isEnabled = await FirebaseMessagingService.requestPermissions();
            await prefs.setInt(lastPermissionRequestKey,
                DateTime.now().millisecondsSinceEpoch);
          }
        } else {
          isEnabled = await FirebaseMessagingService.requestPermissions();
          await prefs.setInt(
              lastPermissionRequestKey, DateTime.now().millisecondsSinceEpoch);
        }
      } else {
        isEnabled = await FirebaseMessagingService.requestPermissions(
            provisional: provisional);
      }

      if (!isEnabled) {
        log('[NotificationRepository] Notification permission NOT enabled');
        if (forceAsk) {
          await AppSettings.openAppSettings(type: AppSettingsType.notification);
        } else {
          await unregisterNotifications();
        }
        return false;
      }

      log('[NotificationRepository] Notification permission enabled successfully');
      return true;
    } catch (e) {
      _handleError('Setup notifications error', e);
      return false;
    }
  }

  // Retry pending notification settings sync
  Future<void> retryPendingSync() async {
    if (_hasPendingChanges && _pendingPreferences != null && _pendingGlobalStatus != null) {
      log('Retrying pending notification settings sync');
      await saveNotificationPreferences(
        _pendingPreferences!,
        _pendingGlobalStatus!,
      );
    }
  }

  // Load notification settings from server
  Future<app_models.NotificationSettings> getNotificationSettings() async {
    try {
      if (_ref == null) {
        throw NotificationException(
          NotificationErrorCode.unknown,
          'Repository not properly initialized with Ref',
        );
      }

      final authData = _ref.read(authProvider);
      if (authData == null || authData.accessToken.isEmpty) {
        throw NotificationException(
          NotificationErrorCode.unknown,
          'User not authenticated',
        );
      }

      return await _notificationService.getNotificationSettings();
    } catch (e) {
      _handleError('Error getting notification settings', e);
      rethrow;
    }
  }

  // Load and save notification settings from server to local storage
  Future<void> loadNotificationSettings() async {
    try {
      if (_ref == null) {
        throw NotificationException(
          NotificationErrorCode.unknown,
          'Repository not properly initialized with Ref',
        );
      }

      final authData = _ref.read(authProvider);
      if (authData == null || authData.accessToken.isEmpty) {
        throw NotificationException(
          NotificationErrorCode.unknown,
          'User not authenticated',
        );
      }

      final settings = await _notificationService.getNotificationSettings();

      // Convert API model to local preferences
      final preferences = NotificationPreferences();
      for (var typeSetting in settings.typeSettings) {
        final notificationType = NotificationTypeExtension.fromTypeCode(typeSetting.typeCode);
        if (notificationType != null) {
          preferences.notifications[notificationType] = typeSetting.isEnabled;
        }
      }

      // Save locally
      await _storageService.saveNotificationPreferences(preferences);

      // Sync FCM topic subscriptions
      await FirebaseMessagingService.updateTopicSubscriptions(preferences.notifications);
    } catch (e) {
      log('Error loading notification settings: $e');
      rethrow;
    }
  }

  Future<void> unregisterNotifications() async {
    try {
      // Mock mode: just clear the mock state
      if (F.useMockService) {
        await _storageService.clearMockNotificationEnabled();
        return;
      }

      // Clear FCM topic subscriptions
      await FirebaseMessagingService.unsubscribeFromAllTopics();

      // Clear local storage
      await _storageService.clearTokenData();
    } catch (e) {
      log('Error unregistering notifications: $e');
      throw NotificationException(NotificationErrorCode.serverError,
          'Failed to unregister notifications: $e');
    }
  }

  void _handleError(String message, dynamic error) {
    log('$message: $error');
    throw NotificationException(
      NotificationErrorCode.serverError,
      '$message: $error',
    );
  }

  Future<NotificationPreferences> getNotificationPreferences() async {
    try {
      return await _storageService.getNotificationPreferences();
    } catch (e) {
      _handleError('Error getting notification preferences', e);
      return NotificationPreferences.defaultPreferences();
    }
  }

  /// Load notification preferences with local-first strategy
  /// Returns local data if available, otherwise fetches from server (first-time user)
  Future<NotificationPreferences> getLocalNotificationPreferencesWithFallback() async {
    try {
      // Check if preferences have been initialized before
      final isInitialized = await _storageService.hasNotificationPreferencesInitialized();

      if (isInitialized) {
        // Has local data, use it (even if all notifications are disabled)
        log('Loaded notification preferences from local storage');
        return await _storageService.getNotificationPreferences();
      }

      // No local data - this is a first-time user, fetch from server
      log('No local data found, fetching from server for first-time initialization');
      try {
        await loadNotificationSettings();
      } catch (e) {
        // Server fetch failed, use defaults and mark as initialized
        log('Server fetch failed during initialization: $e');
        final defaultPrefs = NotificationPreferences.defaultPreferences();
        await _storageService.saveNotificationPreferences(defaultPrefs);
        return defaultPrefs;
      }

      // Return the newly loaded preferences
      return await _storageService.getNotificationPreferences();
    } catch (e) {
      log('Error in getLocalNotificationPreferencesWithFallback: $e');
      // On error, return default preferences
      return NotificationPreferences.defaultPreferences();
    }
  }

  Future<bool> getNotificationEnabled() async {
    // Mock mode: return stored mock state
    if (F.useMockService) {
      return await _storageService.getMockNotificationEnabled();
    }

    final status = await Permission.notification.status;
    log('Notification permission status: $status');
    return await Permission.notification.isGranted ||
        await Permission.notification.isProvisional;
  }

  Future<void> saveNotificationPreferences(
    NotificationPreferences preferences,
    bool globalStatus,
  ) async {
    try {
      // Save locally first
      await _storageService.saveNotificationPreferences(preferences);

      // Update FCM topic subscriptions immediately
      await FirebaseMessagingService.updateTopicSubscriptions(preferences.notifications);

      // Try to sync to server
      try {
        if (_ref == null) {
          log('Repository not properly initialized with Ref - skipping server sync');
          return;
        }

        final authData = _ref.read(authProvider);
        if (authData == null || authData.accessToken.isEmpty) {
          log('User not authenticated - skipping server sync');
          return;
        }

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _notificationService.updateNotificationSettings(
            globalStatus: globalStatus,
            preferences: preferences.notifications,
            fcmToken: fcmToken,
          );
          _hasPendingChanges = false;  // Clear dirty flag on success
          log('Notification settings synced to server successfully');
        }
      } catch (e) {
        // Mark as pending for retry
        _hasPendingChanges = true;
        _pendingPreferences = preferences;
        _pendingGlobalStatus = globalStatus;
        log('Failed to sync notification settings to server: $e');
        // Don't throw - allow silent failure with retry
      }
    } catch (e) {
      _handleError('Error saving notification preferences', e);
    }
  }
}
