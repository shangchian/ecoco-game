// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpResponse _$SendOtpResponseFromJson(Map<String, dynamic> json) =>
    SendOtpResponse(
      action: $enumDecode(_$SendOtpActionEnumMap, json['action']),
      otpExpiresAt: DateTime.parse(json['otpExpiresIn'] as String),
      resendAvailableAt: DateTime.parse(json['resendAvailableAt'] as String),
    );

Map<String, dynamic> _$SendOtpResponseToJson(SendOtpResponse instance) =>
    <String, dynamic>{
      'action': _$SendOtpActionEnumMap[instance.action]!,
      'otpExpiresIn': instance.otpExpiresAt.toIso8601String(),
      'resendAvailableAt': instance.resendAvailableAt.toIso8601String(),
    };

const _$SendOtpActionEnumMap = {
  SendOtpAction.sent: 'SENT',
  SendOtpAction.existed: 'EXISTED',
};
