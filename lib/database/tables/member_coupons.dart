import 'package:drift/drift.dart';
import '../converters/redemption_credentials_converter.dart';

@DataClassName('MemberCouponEntity')
class MemberCoupons extends Table {
  // Primary Key (maps to memberCouponId from API)
  TextColumn get id => text()();

  // Foreign Key to CouponRules
  TextColumn get couponRuleId => text()();

  // Status (UNAVAILABLE, ACTIVE, USED, EXPIRED, REVOKED, HOLDING, CANCELED)
  TextColumn get currentStatus => text()();

  // Timestamps (ISO 8601 Strings stored as Text or DateTime)
  // API returns ISO 8601 strings. Storing as DateTime for easier querying in Drift.
  DateTimeColumn get issuedAt => dateTime()();
  DateTimeColumn get useStartAt => dateTime()();
  DateTimeColumn get expiredAt => dateTime().nullable()();
  DateTimeColumn get usedAt => dateTime().nullable()();
  DateTimeColumn get canceledAt => dateTime().nullable()();
  DateTimeColumn get revokedAt => dateTime().nullable()();
  DateTimeColumn get lastUpdatedAt => dateTime()();

  // Credentials (JSON list)
  TextColumn get redemptionCredentials =>
      text().map(const RedemptionCredentialsConverter())();
      
  // Number of points used for exchange
  IntColumn get exchangeUnits => integer().nullable()();
  
  // Local cache timestamp
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
