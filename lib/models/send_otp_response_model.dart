import 'package:json_annotation/json_annotation.dart';

part 'send_otp_response_model.g.dart';

enum SendOtpAction {
  @JsonValue('SENT')
  sent,
  @JsonValue('EXISTED')
  existed,
}

@JsonSerializable()
class SendOtpResponse {
  final SendOtpAction action;

  @JsonKey(name: 'otpExpiresIn')
  final DateTime otpExpiresAt;

  final DateTime resendAvailableAt;

  const SendOtpResponse({
    required this.action,
    required this.otpExpiresAt,
    required this.resendAvailableAt,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);
}
