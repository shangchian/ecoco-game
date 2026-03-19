import 'package:json_annotation/json_annotation.dart';

part 'profile_data_model.g.dart';

// Custom converter to handle memberId as String, int, or double
String _memberIdFromJson(dynamic value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toInt().toString();
  return "0"; // fallback to default
}

// Custom converter to handle areaId as String, int, or null
String? _areaIdFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is int) return value.toString();
  return null;
}

// Custom converter to handle districtId as String, int, or null
String? _districtIdFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is int) return value.toString();
  return null;
}

@JsonSerializable()
class ProfileData {
  @JsonKey(fromJson: _memberIdFromJson)
  final String memberId;
  final String memberStatus;
  final String? phone;
  final String? email;
  final String? nickname;
  final String? gender;
  final String? birthday;
  @JsonKey(fromJson: _areaIdFromJson)
  final String? areaId;
  @JsonKey(fromJson: _districtIdFromJson)
  final String? districtId;
  final String? avatarUrl;
  final bool isPhoneVerified;
  final bool isGenderEditable;
  final bool isBirthdayEditable;
  final String? lineUserId;
  final String? lineBoundAt;

  ProfileData({
    required this.memberId,
    required this.memberStatus,
    this.phone,
    this.email,
    this.nickname,
    this.gender,
    this.birthday,
    this.areaId,
    this.districtId,
    this.avatarUrl,
    required this.isPhoneVerified,
    required this.isGenderEditable,
    required this.isBirthdayEditable,
    this.lineUserId,
    this.lineBoundAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
