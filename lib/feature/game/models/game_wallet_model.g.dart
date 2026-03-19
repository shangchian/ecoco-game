// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameWalletModel _$GameWalletModelFromJson(Map<String, dynamic> json) =>
    _GameWalletModel(
      gameGold: (json['gameGold'] as num?)?.toInt() ?? 0,
      ecocoPoints: (json['ecocoPoints'] as num?)?.toInt() ?? 0,
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
    );

Map<String, dynamic> _$GameWalletModelToJson(_GameWalletModel instance) =>
    <String, dynamic>{
      'gameGold': instance.gameGold,
      'ecocoPoints': instance.ecocoPoints,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
    };
