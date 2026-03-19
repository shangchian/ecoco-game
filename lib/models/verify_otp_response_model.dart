import 'package:json_annotation/json_annotation.dart';
import '/utils/token_validator.dart';

part 'verify_otp_response_model.g.dart';

@JsonSerializable()
class VerifyOtpResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String accessTokenExpiresAt;
  final String refreshTokenExpiresAt;
  final String memberId;
  final String memberStatus; // "TEMPORARY" for registration flow

  const VerifyOtpResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
    required this.memberId,
    required this.memberStatus,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);

  /// Check if access token needs refresh (expired or expiring within 2 minutes)
  bool get needsRefresh => TokenValidator.needsRefresh(accessTokenExpiresAt);

  /// Check if access token is expired
  bool get isAccessTokenExpired => TokenValidator.isTokenExpired(accessTokenExpiresAt);

  /// Check if refresh token is expired
  bool get isRefreshTokenExpired => TokenValidator.isTokenExpired(refreshTokenExpiresAt);

  /// Create a new instance with updated tokens
  VerifyOtpResponse copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? accessTokenExpiresAt,
    String? refreshTokenExpiresAt,
    String? memberId,
    String? memberStatus,
  }) {
    return VerifyOtpResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshTokenExpiresAt: refreshTokenExpiresAt ?? this.refreshTokenExpiresAt,
      memberId: memberId ?? this.memberId,
      memberStatus: memberStatus ?? this.memberStatus,
    );
  }
}
