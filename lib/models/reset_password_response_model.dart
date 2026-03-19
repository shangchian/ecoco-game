import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_model.g.dart';

@JsonSerializable()
class ResetPasswordResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String accessTokenExpiresAt;
  final String refreshTokenExpiresAt;
  final String memberId;
  final String memberStatus; // "REGISTERED" for password reset flow

  const ResetPasswordResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
    required this.memberId,
    required this.memberStatus,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}
