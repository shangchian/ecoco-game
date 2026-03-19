// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_reset_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResetResponse _$VerifyOtpResetResponseFromJson(
  Map<String, dynamic> json,
) => VerifyOtpResetResponse(
  resetToken: json['resetToken'] as String,
  expiresAt: json['expiresAt'] as String,
  memberId: json['memberId'] as String,
  memberStatus: json['memberStatus'] as String,
);

Map<String, dynamic> _$VerifyOtpResetResponseToJson(
  VerifyOtpResetResponse instance,
) => <String, dynamic>{
  'resetToken': instance.resetToken,
  'expiresAt': instance.expiresAt,
  'memberId': instance.memberId,
  'memberStatus': instance.memberStatus,
};
