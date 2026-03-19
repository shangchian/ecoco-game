import 'package:json_annotation/json_annotation.dart';

part 'member_delete_reason_model.g.dart';

@JsonSerializable()
class DeleteReason {
  final String id;
  final String name;

  DeleteReason({required this.id, required this.name});

  factory DeleteReason.fromJson(Map<String, dynamic> json) =>
      _$DeleteReasonFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteReasonToJson(this);
}

@JsonSerializable()
class DeleteReasonKind {
  final String kindId;
  final String kindName;
  final List<DeleteReason> reasons;

  DeleteReasonKind({
    required this.kindId,
    required this.kindName,
    required this.reasons,
  });

  factory DeleteReasonKind.fromJson(Map<String, dynamic> json) =>
      _$DeleteReasonKindFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteReasonKindToJson(this);
}

@JsonSerializable()
class DeleteReasonsResponse {
  final List<DeleteReasonKind> result;

  DeleteReasonsResponse({required this.result});

  factory DeleteReasonsResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteReasonsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteReasonsResponseToJson(this);
}
