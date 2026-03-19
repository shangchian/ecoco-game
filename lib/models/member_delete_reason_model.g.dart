// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_delete_reason_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteReason _$DeleteReasonFromJson(Map<String, dynamic> json) =>
    DeleteReason(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$DeleteReasonToJson(DeleteReason instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

DeleteReasonKind _$DeleteReasonKindFromJson(Map<String, dynamic> json) =>
    DeleteReasonKind(
      kindId: json['kindId'] as String,
      kindName: json['kindName'] as String,
      reasons: (json['reasons'] as List<dynamic>)
          .map((e) => DeleteReason.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeleteReasonKindToJson(DeleteReasonKind instance) =>
    <String, dynamic>{
      'kindId': instance.kindId,
      'kindName': instance.kindName,
      'reasons': instance.reasons,
    };

DeleteReasonsResponse _$DeleteReasonsResponseFromJson(
  Map<String, dynamic> json,
) => DeleteReasonsResponse(
  result: (json['result'] as List<dynamic>)
      .map((e) => DeleteReasonKind.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DeleteReasonsResponseToJson(
  DeleteReasonsResponse instance,
) => <String, dynamic>{'result': instance.result};
