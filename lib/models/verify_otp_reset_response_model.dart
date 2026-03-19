import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_reset_response_model.g.dart';

@JsonSerializable()
class VerifyOtpResetResponse {
  final String resetToken;
  final String expiresAt;
  final String memberId;
  final String memberStatus; // "REGISTERED" for password reset flow

  const VerifyOtpResetResponse({
    required this.resetToken,
    required this.expiresAt,
    required this.memberId,
    required this.memberStatus,
  });

  factory VerifyOtpResetResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResetResponseToJson(this);
}
