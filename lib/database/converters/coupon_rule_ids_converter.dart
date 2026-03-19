import 'dart:convert';
import 'package:drift/drift.dart';

// Converter for List<String> (coupon rule IDs) to/from JSON string
class CouponRuleIdsConverter extends TypeConverter<List<String>, String> {
  const CouponRuleIdsConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> items = json.decode(fromDb);
    return items.map((e) => e.toString()).toList();
  }

  @override
  String toSql(List<String> value) {
    if (value.isEmpty) return '[]';
    return json.encode(value);
  }
}
