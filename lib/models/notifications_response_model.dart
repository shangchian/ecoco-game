import 'notification_item_model.dart';

/// Response model for notifications API/S3
class NotificationsResponse {
  final List<NotificationItemModel> announcements;
  final List<NotificationItemModel> campaigns;
  final String? etag;
  final String? lastModified;

  NotificationsResponse({
    required this.announcements,
    required this.campaigns,
    this.etag,
    this.lastModified,
  });
}

/// Exception thrown when the cache is not modified (304 response)
class NotificationsCacheNotModifiedException implements Exception {
  @override
  String toString() => 'Notifications cache is not modified (304)';
}

/// Exception thrown when fetching notifications fails
class NotificationsFetchException implements Exception {
  final String message;
  NotificationsFetchException(this.message);

  @override
  String toString() => 'NotificationsFetchException: $message';
}

/// Model for tracking unread notification counts
class UnreadNotificationCounts {
  final int announcements;
  final int campaigns;
  final int personal;

  UnreadNotificationCounts({
    this.announcements = 0,
    this.campaigns = 0,
    this.personal = 0,
  });

  int get total => announcements + campaigns + personal;

  bool get hasUnread => total > 0;
}
