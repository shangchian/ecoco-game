// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  memberId: _memberIdFromJson(json['memberId']),
  memberStatus: json['memberStatus'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  nickname: json['nickname'] as String?,
  gender: json['gender'] as String?,
  birthday: json['birthday'] as String?,
  areaId: _areaIdFromJson(json['areaId']),
  districtId: _districtIdFromJson(json['districtId']),
  avatarUrl: json['avatarUrl'] as String?,
  isPhoneVerified: json['isPhoneVerified'] as bool,
  isGenderEditable: json['isGenderEditable'] as bool,
  isBirthdayEditable: json['isBirthdayEditable'] as bool,
  lineUserId: json['lineUserId'] as String?,
  lineBoundAt: json['lineBoundAt'] as String?,
);

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'memberStatus': instance.memberStatus,
      'phone': instance.phone,
      'email': instance.email,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'areaId': instance.areaId,
      'districtId': instance.districtId,
      'avatarUrl': instance.avatarUrl,
      'isPhoneVerified': instance.isPhoneVerified,
      'isGenderEditable': instance.isGenderEditable,
      'isBirthdayEditable': instance.isBirthdayEditable,
      'lineUserId': instance.lineUserId,
      'lineBoundAt': instance.lineBoundAt,
    };
