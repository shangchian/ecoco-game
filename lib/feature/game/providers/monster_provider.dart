import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/monster_model.dart';
import '../../../providers/location_provider.dart';

part 'monster_provider.g.dart';

@Riverpod(keepAlive: true)
class Monsters extends _$Monsters {
  Timer? _cleanupTimer;
  static const Duration _ttlThreshold = Duration(minutes: 20);

  /// The target number of monsters in the vicinity, 統會維持玩家周圍地圖上有 5 隻怪。
  static const int _targetMonsterCount = 5;

  /// Distance threshold to trigger replenishment (meters)
  static const double _gridSensitivity = 100.0;
  
  LocationData? _lastGenerationPoint;

  @override
  List<MonsterModel> build() {
    // Start cleanup timer, 會自動清理過期的怪物，模擬怪物自然的消失行為。
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _cleanupExpiredMonsters();
    });
    
    ref.onDispose(() {
      _cleanupTimer?.cancel();
    });

    // We don't call refreshMonsters() here because location might not be ready.
    // It will be called by the UI (GameHomeScreen/MapView)
    return [];
  }

  void _cleanupExpiredMonsters() {
    final now = DateTime.now();
    final currentMonsters = state;
    final validMonsters = currentMonsters.where((m) {
      return now.difference(m.spawnTime) < _ttlThreshold;
    }).toList();

    if (validMonsters.length != currentMonsters.length) {
      state = validMonsters;
    }
  }

  void refreshMonsters() {
    final locationState = ref.read(userLocationProvider);
    final location = locationState.location;
    
    // Check if we already have monsters and if the player hasn't moved much
    // This implements the "Movement Sensitivity / Grid Detection" logic
    if (state.isNotEmpty && _lastGenerationPoint != null) {
      final double distanceMoved = ref.read(userLocationProvider.notifier).calculateDistance(
        _lastGenerationPoint!.lat,
        _lastGenerationPoint!.lng,
        location.lat,
        location.lng,
      );
      
      if (distanceMoved < _gridSensitivity) {
        // Player hasn't moved enough to justify a refresh/replenish
        // Still, cleanup expired ones
        _cleanupExpiredMonsters();
        return;
      }
    }

    _lastGenerationPoint = location;
    _replenishMonsters(location);
  }

  void _replenishMonsters(LocationData location) {
    final Random random = Random();
    final List<MonsterModel> currentMonsters = List.from(state);
    final now = DateTime.now();
    
    // 1. Cleanup expired ones first
    currentMonsters.removeWhere((m) => now.difference(m.spawnTime) >= _ttlThreshold);
    
    // 2. Count active monsters in vicinity (e.g. within 500m)
    // For mock, we just assume any monster in 'state' is in the vicinity
    
    if (currentMonsters.length >= _targetMonsterCount) {
      state = currentMonsters;
      return;
    }

    // 3. Replenish up to target count
    final int toAdd = _targetMonsterCount - currentMonsters.length;
    
    for (int i = 0; i < toAdd; i++) {
      // Random offset between -0.003 and +0.003 (approx 300m)
      double latOffset = (random.nextDouble() - 0.5) * 0.006;
      double lngOffset = (random.nextDouble() - 0.5) * 0.006;
      
      int level = 1 + random.nextInt(10);
      final MonsterType type = MonsterType.values[random.nextInt(MonsterType.values.length)];
      String name = '未知怪獸';
      String desc = '出現在地圖上的神祕生物。';
      
      if (type == MonsterType.recycleBeast) {
        name = '回收小獸';
        desc = '由廢棄寶特瓶構成的調皮怪獸。';
      } else if (type == MonsterType.carbonCreature) {
        name = '碳煙怪';
        desc = '散發著濃煙的憂鬱怪獸。';
      } else if (type == MonsterType.ecoGuardian) {
        name = '環保衛士';
        desc = '守護森林的神祕生物。';
      }

      currentMonsters.add(
        MonsterModel(
          id: 'spawn_${DateTime.now().millisecondsSinceEpoch}_$i',
          name: name,
          description: desc,
          type: type,
          latitude: location.lat + latOffset,
          longitude: location.lng + lngOffset,
          level: level,
          currentHp: 100 + (level * 20),
          spawnTime: now.add(Duration(seconds: random.nextInt(60))), // slight staggered start
        ),
      );
    }
    
    state = currentMonsters;
  }

  /// Update monster positions or status (to be used with Firestore later)
  void updateMonsters(List<MonsterModel> monsters) {
    state = monsters;
  }
}
