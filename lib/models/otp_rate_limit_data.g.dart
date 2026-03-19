// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_rate_limit_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRateLimitData _$OtpRateLimitDataFromJson(Map<String, dynamic> json) =>
    OtpRateLimitData(
      count: (json['count'] as num).toInt(),
      lastResetDate: json['lastResetDate'] as String,
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$OtpRateLimitDataToJson(OtpRateLimitData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'lastResetDate': instance.lastResetDate,
      'timezone': instance.timezone,
    };
