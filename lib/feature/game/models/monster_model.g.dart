// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monster_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonsterModel _$MonsterModelFromJson(Map<String, dynamic> json) => MonsterModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$MonsterTypeEnumMap, json['type']),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  level: (json['level'] as num?)?.toInt() ?? 1,
  baseHp: (json['baseHp'] as num?)?.toInt() ?? 100,
  currentHp: (json['currentHp'] as num).toInt(),
  rewardPoints: (json['rewardPoints'] as num?)?.toInt() ?? 10,
  spawnTime: DateTime.parse(json['spawnTime'] as String),
);

Map<String, dynamic> _$MonsterModelToJson(MonsterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$MonsterTypeEnumMap[instance.type]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'level': instance.level,
      'baseHp': instance.baseHp,
      'currentHp': instance.currentHp,
      'rewardPoints': instance.rewardPoints,
      'spawnTime': instance.spawnTime.toIso8601String(),
    };

const _$MonsterTypeEnumMap = {
  MonsterType.recycleBeast: 'recycleBeast',
  MonsterType.carbonCreature: 'carbonCreature',
  MonsterType.ecoGuardian: 'ecoGuardian',
};
