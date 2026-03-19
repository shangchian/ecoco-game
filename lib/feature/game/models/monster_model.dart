import 'package:json_annotation/json_annotation.dart';

part 'monster_model.g.dart';

/// Monster types available in the game
enum MonsterType {
  recycleBeast,
  carbonCreature,
  ecoGuardian,
}

/// Model representing a monster on the game map
@JsonSerializable()
class MonsterModel {
  final String id;
  final String name;
  final String description;
  final MonsterType type;
  final double latitude;
  final double longitude;
  final int level;
  final int baseHp;
  final int currentHp;
  final int rewardPoints;
  final DateTime spawnTime;

  MonsterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.level = 1,
    this.baseHp = 100,
    required this.currentHp,
    this.rewardPoints = 10,
    required this.spawnTime,
  });

  factory MonsterModel.fromJson(Map<String, dynamic> json) =>
      _$MonsterModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonsterModelToJson(this);

  /// Path to the monster's map icon asset
  String get assetPath {
    switch (type) {
      case MonsterType.recycleBeast:
        return 'assets/images/game/recycle_beast.png';
      case MonsterType.carbonCreature:
        return 'assets/images/game/carbon_creature.png';
      case MonsterType.ecoGuardian:
        return 'assets/images/game/eco_guardian.png';
    }
  }

  /// Create a copy with updated fields
  MonsterModel copyWith({
    String? id,
    String? name,
    String? description,
    MonsterType? type,
    double? latitude,
    double? longitude,
    int? level,
    int? baseHp,
    int? currentHp,
    int? rewardPoints,
    DateTime? spawnTime,
  }) {
    return MonsterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      level: level ?? this.level,
      baseHp: baseHp ?? this.baseHp,
      currentHp: currentHp ?? this.currentHp,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      spawnTime: spawnTime ?? this.spawnTime,
    );
  }
}
