import 'package:drift/drift.dart';
import '/database/converters/item_status_list_converter.dart';
import '/database/converters/bin_status_list_converter.dart';

@DataClassName('SiteStatusEntity')
class SiteStatuses extends Table {
  // Foreign key to Sites
  TextColumn get siteId => text()();

  // Status information
  TextColumn get displayStatus => text()();
  TextColumn get cardType => text().nullable()();
  BoolColumn get isOffHours => boolean().nullable()();

  // Item status list (JSON)
  TextColumn get itemStatusList => text().map(const ItemStatusListConverter()).nullable()();

  // Bin status list (JSON)
  TextColumn get binStatusList => text().map(const BinStatusListConverter()).nullable()();

  // Cache metadata
  DateTimeColumn get statusCachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {siteId};
}
