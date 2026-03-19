import 'dart:convert';
import 'package:drift/drift.dart';
import '/models/site_status_model.dart';

// Converter for List<ItemStatus> to/from JSON string
class ItemStatusListConverter extends TypeConverter<List<ItemStatus>, String> {
  const ItemStatusListConverter();

  @override
  List<ItemStatus> fromSql(String fromDb) {
    final List<dynamic> items = json.decode(fromDb);
    return items.map((e) => ItemStatus.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  String toSql(List<ItemStatus> value) {
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}
