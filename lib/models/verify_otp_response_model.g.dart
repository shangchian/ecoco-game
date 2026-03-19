// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      accessTokenExpiresAt: json['accessTokenExpiresAt'] as String,
      refreshTokenExpiresAt: json['refreshTokenExpiresAt'] as String,
      memberId: json['memberId'] as String,
      memberStatus: json['memberStatus'] as String,
    );

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt,
      'refreshTokenExpiresAt': instance.refreshTokenExpiresAt,
      'memberId': instance.memberId,
      'memberStatus': instance.memberStatus,
    };
