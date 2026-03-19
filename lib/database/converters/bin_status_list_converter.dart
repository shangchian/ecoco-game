import 'dart:convert';
import 'package:drift/drift.dart';
import '/models/site_status_model.dart';

// Converter for List<BinStatus> to/from JSON string
class BinStatusListConverter extends TypeConverter<List<BinStatus>, String> {
  const BinStatusListConverter();

  @override
  List<BinStatus> fromSql(String fromDb) {
    final List<dynamic> items = json.decode(fromDb);
    return items.map((e) => BinStatus.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  String toSql(List<BinStatus> value) {
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}
