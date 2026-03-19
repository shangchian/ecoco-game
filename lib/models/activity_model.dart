import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel {
  final String id;
  final String title;
  final String subtitle;
  final String iconUrl;
  final String? couponRuleId;

  ActivityModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    this.couponRuleId,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
