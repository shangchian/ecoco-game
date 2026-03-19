import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

// Custom converter to handle memberId as String, int, or double
String _memberIdFromJson(dynamic value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toInt().toString();
  return "0";
}

@JsonSerializable(includeIfNull: true)
class ExpiryDetails {
  @JsonKey(name: "isExpiringSoon", defaultValue: false)
  final bool isExpiringSoon;

  @JsonKey(name: "nextExpiryAmount", defaultValue: 0)
  final int nextExpiryAmount;

  @JsonKey(name: "nextExpiryDate")
  final String? nextExpiryDate;  // ISO 8601 UTC, nullable

  const ExpiryDetails({
    required this.isExpiringSoon,
    required this.nextExpiryAmount,
    this.nextExpiryDate,
  });

  factory ExpiryDetails.fromJson(Map<String, dynamic> json) =>
      _$ExpiryDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiryDetailsToJson(this);
}

@JsonSerializable(includeIfNull: true)
class Wallet {
  @JsonKey(name: "currencyCode", defaultValue: "")
  final String currencyCode;  // "ECOCO_POINT" or "DAKA"

  @JsonKey(name: "currencyName", defaultValue: "")
  final String currencyName;  // Display name

  @JsonKey(name: "currentBalance", defaultValue: 0)
  final int currentBalance;

  @JsonKey(name: "expiryDetails")
  final ExpiryDetails expiryDetails;

  const Wallet({
    required this.currencyCode,
    required this.currencyName,
    required this.currentBalance,
    required this.expiryDetails,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) =>
      _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  // Helper getters
  bool get isEcocoPoint => currencyCode == 'ECOCO_POINT';
  bool get isDaka => currencyCode == 'DAKA';
}

@JsonSerializable(includeIfNull: true)
class WalletData {
  @JsonKey(name: "memberId", fromJson: _memberIdFromJson, defaultValue: "0")
  final String memberId;

  @JsonKey(name: "wallets", defaultValue: [])
  final List<Wallet> wallets;

  const WalletData({
    required this.memberId,
    required this.wallets,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);

  // Convenience getters with fallback defaults
  Wallet get ecocoWallet {
    try {
      return wallets.firstWhere((w) => w.currencyCode == 'ECOCO_POINT');
    } catch (e) {
      return const Wallet(
        currencyCode: 'ECOCO_POINT',
        currencyName: 'ECOCO點數',
        currentBalance: 0,
        expiryDetails: ExpiryDetails(
          isExpiringSoon: false,
          nextExpiryAmount: 0,
          nextExpiryDate: null,
        ),
      );
    }
  }

  Wallet get dakaWallet {
    try {
      return wallets.firstWhere((w) => w.currencyCode == 'DAKA');
    } catch (e) {
      return const Wallet(
        currencyCode: 'DAKA',
        currencyName: 'DAKA點數',
        currentBalance: 0,
        expiryDetails: ExpiryDetails(
          isExpiringSoon: false,
          nextExpiryAmount: 0,
          nextExpiryDate: null,
        ),
      );
    }
  }

  Wallet get ntpWallet {
    try {
      return wallets.firstWhere((w) => w.currencyCode == 'NTP');
    } catch (e) {
      return const Wallet(
        currencyCode: 'NTP',
        currencyName: '新北幣',
        currentBalance: 0,
        expiryDetails: ExpiryDetails(
          isExpiringSoon: false,
          nextExpiryAmount: 0,
          nextExpiryDate: null,
        ),
      );
    }
  }
}
