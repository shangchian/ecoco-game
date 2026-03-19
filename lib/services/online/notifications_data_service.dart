import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/notification_item_model.dart';
import '/models/notifications_response_model.dart';
import '/services/s3_storage_service.dart';
import '/services/interface/i_notifications_data_service.dart';
import '/flavors.dart';

class NotificationsDataService implements INotificationsDataService {
  final _s3Service = S3StorageService();

  @override
  Future<NotificationsResponse> fetchNotifications({
    String? etag,
    String? lastModified,
  }) async {
    try {
      // Add timestamp to force fresh fetch (bypass CDN/cache)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '${F.notificationsUrl}?t=$timestamp';

      final response = await _s3Service.fetchFromS3(
        url: url,
        etag: etag,
        lastModified: lastModified,
      );

      if (response.statusCode == 304) {
        throw NotificationsCacheNotModifiedException();
      }

      if (response.statusCode == 403) {
        throw NotificationsFetchException('Notifications file not found on S3 (403)');
      }

      if (response.statusCode == 200) {
        final newEtag = response.headers.value('etag');
        final newLastModified = response.headers.value('last-modified');

        final dynamic data = response.data;

        if (data is! Map || !data.containsKey('result')) {
          throw NotificationsFetchException('Unexpected response format from S3');
        }

        final result = data['result'];
        final announcements = _parseNotificationItems(result['announcements'] as List? ?? []);
        final campaigns = _parseNotificationItems(result['campaigns'] as List? ?? []);

        return NotificationsResponse(
          announcements: announcements,
          campaigns: campaigns,
          etag: newEtag,
          lastModified: newLastModified,
        );
      }

      throw NotificationsFetchException('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      log('Error fetching notifications: $e');
      rethrow;
    }
  }

  @override
  Future<NotificationsResponse> loadBundledNotifications() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/notifications.json');
      final dynamic json = jsonDecode(jsonString);

      if (json is! Map || !json.containsKey('result')) {
        throw Exception('Unexpected format in bundled notifications.json');
      }

      final result = json['result'];
      final announcements = _parseNotificationItems(result['announcements'] as List? ?? []);
      final campaigns = _parseNotificationItems(result['campaigns'] as List? ?? []);

      return NotificationsResponse(
        announcements: announcements,
        campaigns: campaigns,
      );
    } catch (e) {
      log('Error loading bundled notifications: $e');
      rethrow;
    }
  }

  List<NotificationItemModel> _parseNotificationItems(List<dynamic> jsonList) {
    return jsonList.map((json) => NotificationItemModel.fromJson(json)).toList();
  }
}
