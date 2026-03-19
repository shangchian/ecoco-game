import 'package:flutter_riverpod/legacy.dart';
import '../models/player_model.dart';

/// Provider for the player's game state
final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerModel>((ref) {
  return PlayerNotifier();
});

class PlayerNotifier extends StateNotifier<PlayerModel> {
  PlayerNotifier() : super(PlayerModel(uid: 'current_user'));

  void updateHp(int delta) {
    int newHp = (state.currentHp + delta).clamp(0, state.maxHp);
    state = state.copyWith(currentHp: newHp);
  }

  void addExp(int exp) {
    int totalExp = state.exp + exp;
    int nextLevelExp = state.level * 100;
    
    if (totalExp >= nextLevelExp) {
      state = state.copyWith(
        level: state.level + 1,
        exp: totalExp - nextLevelExp,
        maxHp: state.maxHp + 20,
        currentHp: state.maxHp + 20,
      );
    } else {
      state = state.copyWith(exp: totalExp);
    }
  }

  void reset() {
    state = PlayerModel(uid: 'current_user');
  }
}
