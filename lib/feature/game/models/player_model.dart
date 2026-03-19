import 'package:json_annotation/json_annotation.dart';

part 'player_model.g.dart';

/// Model representing the player's game stats
@JsonSerializable()
class PlayerModel {
  final String uid;
  final int level;
  final int exp;
  final int maxHp;
  final int currentHp;
  final int maxMp;
  final int currentMp;
  final int energy;

  PlayerModel({
    required this.uid,
    this.level = 1,
    this.exp = 0,
    this.maxHp = 100,
    this.currentHp = 100,
    this.maxMp = 50,
    this.currentMp = 50,
    this.energy = 100,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);

  /// Create a copy with updated fields
  PlayerModel copyWith({
    String? uid,
    int? level,
    int? exp,
    int? maxHp,
    int? currentHp,
    int? maxMp,
    int? currentMp,
    int? energy,
  }) {
    return PlayerModel(
      uid: uid ?? this.uid,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      maxMp: maxMp ?? this.maxMp,
      currentMp: currentMp ?? this.currentMp,
      energy: energy ?? this.energy,
    );
  }
}
