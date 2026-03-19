import 'package:drift/drift.dart';
import '/database/converters/coupon_rule_ids_converter.dart';
import '/database/converters/carousel_list_converter.dart';

@DataClassName('CouponRuleEntity')
class CouponRules extends Table {
  // Primary Key (maps to couponRuleId from API)
  TextColumn get id => text()();

  // Status
  BoolColumn get isActive => boolean()();

  // Category and basic info
  TextColumn get categoryCode => text()();
  TextColumn get title => text()();

  // Brand association
  TextColumn get brandId => text()();
  TextColumn get brandName => text()();

  // Display
  TextColumn get cardImageUrl => text().nullable()();
  TextColumn get donationCode => text().nullable()();
  BoolColumn get isPremium => boolean()();
  TextColumn get promoLabel => text().nullable()();
  TextColumn get shortNotice => text().nullable()();

  // Pricing
  IntColumn get unitPrice => integer()();
  TextColumn get displayUnit => text()();
  TextColumn get currencyCode => text()();
  TextColumn get exchangeDisplayText => text()();

  // Exchange configuration
  TextColumn get exchangeInputType => text()();
  TextColumn get exchangeFlowType => text()();
  TextColumn get assetRedeemType => text()();
  IntColumn get maxPerExchangeCount => integer().nullable()();
  IntColumn get exchangeStepValue => integer()();

  // Geofence restrictions (JSON array of area IDs)
  TextColumn get geofenceAreaIds =>
      text().map(const CouponRuleIdsConverter())();

  // Validity period (UTC timestamps)
  DateTimeColumn get exchangeableStartAt => dateTime()();
  DateTimeColumn get exchangeableEndAt => dateTime().nullable()();

  // Last updated timestamp
  DateTimeColumn get lastUpdatedAt => dateTime()();

  // Carousel media content (JSON array)
  TextColumn get carouselList =>
      text().map(const CarouselListConverter())();

  // Alert and external redemption
  TextColumn get exchangeAlert => text().nullable()();
  TextColumn get externalRedemptionUrl => text().nullable()();

  // Markdown documentation URLs
  TextColumn get rulesSummaryMdUrl => text()();
  TextColumn get redemptionTermsMdUrl => text()();
  TextColumn get userInstructionMdUrl => text().nullable()();
  TextColumn get staffInstructionMdUrl => text().nullable()();

  // Display order
  IntColumn get sortOrder => integer()();

  // Cache metadata
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
