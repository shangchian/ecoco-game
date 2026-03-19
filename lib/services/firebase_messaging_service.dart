import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/notification_preferences.dart' as pref;
import '/models/notification_item_model.dart';
import '/providers/app_database_provider.dart';
import '/repositories/notifications_data_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
  log('Message data: ${message.data}');

  try {
    // Create an independent ProviderContainer for background isolate
    final container = ProviderContainer();
    final db = container.read(appDatabaseProvider);
    final repository = NotificationsDataRepository(db: db);

    await FirebaseMessagingService.processMessageData(message.data, repository);
    
    // Cleanup container
    container.dispose();
  } catch (e) {
    log('Error processing background message: $e');
  }
}

class FirebaseMessagingService {
  static Future<void> init(ProviderContainer container) async {
    await requestPermissions();
    
    // Enable foreground notification presentation for iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _setupForegroundMessageHandler(container);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Subscribe to 'all' topic for general broadcasts
    log('[FirebaseMessagingService] Subscribing to default "all" topic');
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  static void _setupForegroundMessageHandler(ProviderContainer container) {
    FirebaseMessaging.onMessage.listen((message) async {
      _handleForegroundMessage(message);
      
      try {
        final db = container.read(appDatabaseProvider);
        final repository = NotificationsDataRepository(db: db);
        
        await processMessageData(message.data, repository);
      } catch (e) {
        log('Error processing foreground message data: $e');
      }
    });
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');
    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  }

  static Future<void> processMessageData(
    Map<String, dynamic> data,
    NotificationsDataRepository repository,
  ) async {
    // 1. Check for S3 Sync action
    if (data['action'] == 'SYNC_S3') {
      log('[FirebaseMessagingService] Triggering S3 Sync');
      await repository.syncNotifications(forceRefresh: true);
    }

    // 2. Check for personal notifications
    if (data.containsKey('personal')) {
      try {
        log('[FirebaseMessagingService] Parsing personal notifications');
        final personalJsonStr = data['personal'] as String;
        final List<dynamic> jsonList = jsonDecode(personalJsonStr);
        final items = jsonList
            .map((json) => NotificationItemModel.fromJson(json as Map<String, dynamic>))
            .toList();

        if (items.isNotEmpty) {
          await repository.insertPersonalNotifications(items);
        }
      } catch (e) {
        log('[FirebaseMessagingService] Failed to parse personal notification data: $e');
      }
    }
  }

  static Future<bool> requestPermissions({bool provisional = false}) async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      provisional: provisional,
      alert: true,
      badge: true,
      sound: true,
    );

    final bool isNotificationsEnabled =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    return isNotificationsEnabled;
  }

  static Future<void> updateTopicSubscriptions(
      Map<pref.NotificationType, bool> preferences) async {
    log('[FirebaseMessagingService] Updating topic subscriptions. Current preferences: $preferences');
    for (var entry in preferences.entries) {
      final topic = entry.key.toString().split('.').last;
      if (entry.value) {
        log('[FirebaseMessagingService] Subscribing to topic: $topic');
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      } else {
        log('[FirebaseMessagingService] Unsubscribing from topic: $topic');
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      }
    }
  }

  static Future<void> unsubscribeFromAllTopics() async {
    await FirebaseMessaging.instance.deleteToken();
  }
}
