import 'package:drift/drift.dart';

@DataClassName('CouponRuleStatusEntity')
class CouponRuleStatuses extends Table {
  // Foreign key to CouponRules (links via couponRuleId)
  TextColumn get couponRuleId => text()();

  // Display status from API (NORMAL or SOLD_OUT)
  TextColumn get displayStatus => text()();

  // Cache metadata
  DateTimeColumn get statusCachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {couponRuleId};
}
