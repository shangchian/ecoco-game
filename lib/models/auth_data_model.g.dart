// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
  memberId: json['memberId'] == null
      ? '0'
      : _memberIdFromJson(json['memberId']),
  accessToken: json['accessToken'] as String? ?? '',
  refreshToken: json['refreshToken'] as String? ?? '',
  tokenType: json['tokenType'] as String? ?? '',
  accessTokenExpiresAt: json['accessTokenExpiresAt'] as String? ?? '',
  refreshTokenExpiresAt: json['refreshTokenExpiresAt'] as String? ?? '',
  memberStatus: json['memberStatus'] as String? ?? '',
);

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
  'memberId': instance.memberId,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenType': instance.tokenType,
  'accessTokenExpiresAt': instance.accessTokenExpiresAt,
  'refreshTokenExpiresAt': instance.refreshTokenExpiresAt,
  'memberStatus': instance.memberStatus,
};
