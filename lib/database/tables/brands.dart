import 'package:drift/drift.dart';
import '/models/brand_model.dart';
import '/database/converters/coupon_rule_ids_converter.dart';

@DataClassName('BrandEntity')
class Brands extends Table {
  // Primary Key
  TextColumn get id => text()();

  // Basic brand information
  BoolColumn get isActive => boolean()();
  TextColumn get name => text()();
  TextColumn get category => textEnum<BrandCategory>().nullable()();
  TextColumn get logoUrl => text().nullable()();
  BoolColumn get isPremium => boolean()();

  // Campaign period (UTC timestamps)
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();

  // Description URL (markdown content loaded on-demand)
  TextColumn get descriptionMdUrl => text().nullable()();

  // Display order
  IntColumn get sortOrder => integer()();

  // Coupon associations (JSON array of IDs)
  TextColumn get couponRuleIds =>
      text().map(const CouponRuleIdsConverter())();

  // Cache metadata
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
