import 'dart:convert';
import 'package:drift/drift.dart';
import '../../models/points_log_model.dart';

@DataClassName('PointLogEntity')
class PointLogs extends Table {
  // Primary Key
  TextColumn get logId => text()();

  // Enums stored as text
  TextColumn get logType => textEnum<LogType>()();
  TextColumn get iconTypeCode => textEnum<IconTypeCode>()();
  TextColumn get detailType => textEnum<DetailType>()();

  // Basic fields
  TextColumn get currencyCode => text()();
  TextColumn get title => text()();
  IntColumn get pointsChange => integer()();
  
  // DateTimes stored as ISO 8601 strings or Int (timestamp). 
  // API returns ISO 8601 strings. Drift DateTime column is convenient.
  // We need to index occurredAt for sorting.
  DateTimeColumn get occurredAt => dateTime()();
  
  // Sync anchor
  DateTimeColumn get lastUpdatedAt => dateTime()();

  // JSON Blob
  TextColumn get detailsRaw => text().map(const DetailsConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {logId};

  @override
  List<Set<Column>> get uniqueKeys => [];

  // Drift 2.0+ way to define indexes
  // If your drift version < 2.0, this might be different, but we installed 2.x
  // Actually, for Drift 2.x, we usually define indexes outside the table or use `customConstraints` properly?
  // Wait, the documentation says:
  // "To create an index, you can override the `indexes` getter in your table." (Older versions)
  // For newer versions, we might need to check.
  // Let's assume standard Drift:
  // @override
  // List<String> get customConstraints => [];
  
  // Actually, let's just use the `indexes` getter if it's available in this version of Drift.
  // If not, we can just execute the SQL in the migration.
  
  // Let's try to look for `indexes` override.
  // But wait, the previous code used `customConstraints` with `CREATE INDEX` which is wrong because `customConstraints` are appended to the `CREATE TABLE` statement.
  
  // Correct way in modern Drift (Dart):
  // override `List<String> get customConstraints` is for things like `UNIQUE (a, b)`.
  // Index creation is separate.
  
  // Let's just remove the invalid customConstraints for now.
  // Drift automatically indexes primary keys.
  // For other columns, we can add `index: true` in the column builder if supported (it is NOT supported directly in column builder).
  
  // So, I will remove the `customConstraints` and instead rely on Drift's generated code or manual migration if strictly needed.
  // However, for performance, we DO want indexes.
  
  // In `drift` files (.drift), it's easy. In Dart files, we can override `indexes`.
  // Let's check if `Table` has `indexes` getter. It DOES NOT in standard Table class (it was proposed).
  
  // The correct way in Dart tables is often to just execute the index creation in the callback or use `.drift` files.
  // Since I am using Dart-only tables, I will remove the faulty constraints.
  // If performance becomes an issue, we can add `CREATE INDEX` in `beforeOpen` or `migration`.
  
  @override
  List<String> get customConstraints => [];
}

class DetailsConverter extends TypeConverter<Map<String, dynamic>, String> {
  const DetailsConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return json.decode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}
