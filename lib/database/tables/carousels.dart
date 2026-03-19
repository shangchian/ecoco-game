import 'package:drift/drift.dart';

/// Table for storing carousel content from S3
class Carousels extends Table {
  /// Unique identifier for the carousel item
  TextColumn get id => text()();

  /// Placement key indicating where the carousel should appear (e.g., HOME_MAIN_CAROUSEL, HOME_POPUP_MODAL)
  TextColumn get placementKey => text()();

  /// Title of the carousel item for identification
  TextColumn get title => text()();

  /// Promotion code for analytics tracking
  TextColumn get promotionCode => text().nullable()();

  /// Media type (STATIC_IMAGE, LOOPING_ANIMATION, LOTTIE, VIDEO)
  TextColumn get mediaType => text()();

  /// URL to the media file
  TextColumn get mediaUrl => text()();

  /// Fallback URL for when primary media fails to load
  TextColumn get fallbackUrl => text().nullable()();

  /// Action type when user taps (APP_PAGE, EXTERNAL_URL, DEEPLINK, NONE)
  TextColumn get actionType => text()();

  /// Target link for the action
  TextColumn get actionLink => text().nullable()();

  /// Sort order for display
  IntColumn get sortOrder => integer()();

  /// When the carousel should start displaying
  DateTimeColumn get publishedAt => dateTime()();

  /// When the carousel should stop displaying (null = no expiration)
  DateTimeColumn get expiredAt => dateTime().nullable()();

  /// Timestamp when this data was last cached from S3
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
