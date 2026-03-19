import 'package:drift/drift.dart';
import '/models/site_model.dart';
import '/database/converters/recyclable_items_converter.dart';

@DataClassName('SiteEntity')
class Sites extends Table {
  // Primary Key
  TextColumn get id => text()();

  // Basic site information
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get siteType => textEnum<SiteType>()();
  TextColumn get address => text()();
  RealColumn get longitude => real()();
  RealColumn get latitude => real()();
  TextColumn get serviceHours => text()();
  TextColumn get areaId => text()();
  TextColumn get districtId => text()();
  TextColumn get note => text().nullable()();

  // Recyclable items stored as JSON array
  TextColumn get recyclableItems => text().map(const RecyclableItemsConverter())();

  // Favorite flag - denormalized for query performance
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  // Cache metadata
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
