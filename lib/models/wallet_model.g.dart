// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpiryDetails _$ExpiryDetailsFromJson(Map<String, dynamic> json) =>
    ExpiryDetails(
      isExpiringSoon: json['isExpiringSoon'] as bool? ?? false,
      nextExpiryAmount: (json['nextExpiryAmount'] as num?)?.toInt() ?? 0,
      nextExpiryDate: json['nextExpiryDate'] as String?,
    );

Map<String, dynamic> _$ExpiryDetailsToJson(ExpiryDetails instance) =>
    <String, dynamic>{
      'isExpiringSoon': instance.isExpiringSoon,
      'nextExpiryAmount': instance.nextExpiryAmount,
      'nextExpiryDate': instance.nextExpiryDate,
    };

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
  currencyCode: json['currencyCode'] as String? ?? '',
  currencyName: json['currencyName'] as String? ?? '',
  currentBalance: (json['currentBalance'] as num?)?.toInt() ?? 0,
  expiryDetails: ExpiryDetails.fromJson(
    json['expiryDetails'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
  'currencyCode': instance.currencyCode,
  'currencyName': instance.currencyName,
  'currentBalance': instance.currentBalance,
  'expiryDetails': instance.expiryDetails,
};

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  memberId: json['memberId'] == null
      ? '0'
      : _memberIdFromJson(json['memberId']),
  wallets:
      (json['wallets'] as List<dynamic>?)
          ?.map((e) => Wallet.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'wallets': instance.wallets,
    };
