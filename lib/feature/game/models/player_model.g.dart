// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
  uid: json['uid'] as String,
  level: (json['level'] as num?)?.toInt() ?? 1,
  exp: (json['exp'] as num?)?.toInt() ?? 0,
  maxHp: (json['maxHp'] as num?)?.toInt() ?? 100,
  currentHp: (json['currentHp'] as num?)?.toInt() ?? 100,
  maxMp: (json['maxMp'] as num?)?.toInt() ?? 50,
  currentMp: (json['currentMp'] as num?)?.toInt() ?? 50,
  energy: (json['energy'] as num?)?.toInt() ?? 100,
);

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'level': instance.level,
      'exp': instance.exp,
      'maxHp': instance.maxHp,
      'currentHp': instance.currentHp,
      'maxMp': instance.maxMp,
      'currentMp': instance.currentMp,
      'energy': instance.energy,
    };
