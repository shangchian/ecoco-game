import 'dart:convert';
import 'package:drift/drift.dart';
import '/models/site_model.dart';

// Converter for List<RecyclableItemType> to/from JSON string
class RecyclableItemsConverter extends TypeConverter<List<RecyclableItemType>, String> {
  const RecyclableItemsConverter();

  @override
  List<RecyclableItemType> fromSql(String fromDb) {
    final List<dynamic> items = json.decode(fromDb);
    return items.map((e) => RecyclableItemType.values.byName(e as String)).toList();
  }

  @override
  String toSql(List<RecyclableItemType> value) {
    return json.encode(value.map((e) => e.name).toList());
  }
}
