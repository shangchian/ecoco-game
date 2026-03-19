import 'package:json_annotation/json_annotation.dart';

part 'bio_auth_model.g.dart';

@JsonSerializable(includeIfNull: true)
class BioAuthData {
  @JsonKey(defaultValue: "")
  final String phone;
  @JsonKey(defaultValue: "")
  final String password;

  const BioAuthData({
    required this.phone,
    required this.password,
  });

  factory BioAuthData.fromJson(Map<String, dynamic> json) => 
      _$BioAuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$BioAuthDataToJson(this);
}
