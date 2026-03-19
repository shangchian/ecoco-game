import '/models/notifications_response_model.dart';

/// Interface for notifications data service (S3 fetch)
abstract class INotificationsDataService {
  /// Fetch notifications from S3 with conditional request support
  Future<NotificationsResponse> fetchNotifications({
    String? etag,
    String? lastModified,
  });

  /// Load bundled notifications from assets (fallback)
  Future<NotificationsResponse> loadBundledNotifications();
}
