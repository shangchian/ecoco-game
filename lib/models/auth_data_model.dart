import 'package:json_annotation/json_annotation.dart';
import '/utils/token_validator.dart';

part 'auth_data_model.g.dart';

// Custom converter to handle memberId as String, int, or double
String _memberIdFromJson(dynamic value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toInt().toString();
  return "0"; // fallback to default
}

@JsonSerializable(includeIfNull: true)
class AuthData {
  @JsonKey(defaultValue: "0", name: "memberId", fromJson: _memberIdFromJson)
  final String memberId;
  @JsonKey(defaultValue: "", name: "accessToken")
  final String accessToken;
  @JsonKey(defaultValue: "", name: "refreshToken")
  final String refreshToken;
  @JsonKey(defaultValue: "", name: "tokenType")
  final String tokenType;
  @JsonKey(defaultValue: "", name: "accessTokenExpiresAt")
  final String accessTokenExpiresAt;
  @JsonKey(defaultValue: "", name: "refreshTokenExpiresAt")
  final String refreshTokenExpiresAt;
  @JsonKey(defaultValue: "", name: "memberStatus")
  final String memberStatus;

  const AuthData({
    required this.memberId,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
    required this.memberStatus,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);

  /// Check if access token needs refresh (expired or expiring within 2 minutes)
  bool get needsRefresh => TokenValidator.needsRefresh(accessTokenExpiresAt);

  /// Check if access token is expired
  bool get isExpired => TokenValidator.isTokenExpired(accessTokenExpiresAt);

  /// Check if access token is expiring soon (within 2-minute buffer)
  bool get isExpiringSoon => TokenValidator.isTokenExpiringSoon(accessTokenExpiresAt);
}