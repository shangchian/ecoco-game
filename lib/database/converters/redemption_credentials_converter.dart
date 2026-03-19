import 'dart:convert';
import 'package:drift/drift.dart';
import '../../models/redemption_credential_model.dart';

class RedemptionCredentialsConverter
    extends TypeConverter<List<RedemptionCredentialModel>, String> {
  const RedemptionCredentialsConverter();

  @override
  List<RedemptionCredentialModel> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = json.decode(fromDb);
      return jsonList
          .map((e) =>
              RedemptionCredentialModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  String toSql(List<RedemptionCredentialModel> value) {
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}
