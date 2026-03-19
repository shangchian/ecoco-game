import 'package:drift/drift.dart';

/// Table for storing notification items (announcements and campaigns) from S3
class Notifications extends Table {
  /// Unique identifier for the notification item
  TextColumn get id => text()();

  /// Notification type: ANNOUNCEMENT or CAMPAIGN
  TextColumn get notificationType => text()();

  /// Title of the notification
  TextColumn get title => text()();

  /// Optional tag text (e.g., "重要")
  TextColumn get tagText => text().nullable()();

  /// Summary/description of the notification
  TextColumn get summary => text()();

  /// When the notification should start displaying (ISO 8601 UTC)
  DateTimeColumn get publishedAt => dateTime()();

  /// When the notification should stop displaying (null = no expiration)
  DateTimeColumn get expiredAt => dateTime().nullable()();

  /// Action type when user taps (LOAD_MARKDOWN, APP_PAGE, EXTERNAL_URL, DEEPLINK, NONE)
  TextColumn get actionType => text()();

  /// Target link for the action (null if actionType = NONE)
  TextColumn get actionLink => text().nullable()();

  /// Whether the user has read this notification (local only)
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  /// When the user read this notification (local only)
  DateTimeColumn get readAt => dateTime().nullable()();

  /// Timestamp when this data was last cached from S3
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
