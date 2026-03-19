import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/providers/shared_preferences_provider.dart';

part 'app_mode_provider.g.dart';

enum AppMode {
  general,
  game,
}

@Riverpod(keepAlive: true)
class AppModeState extends _$AppModeState {
  static const _key = 'app_mode';

  @override
  AppMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final modeIndex = prefs.getInt(_key);
    if (modeIndex != null && modeIndex < AppMode.values.length) {
      return AppMode.values[modeIndex];
    }
    return AppMode.general;
  }

  Future<void> toggleMode() async {
    final newMode = state == AppMode.general ? AppMode.game : AppMode.general;
    state = newMode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_key, newMode.index);
  }
}
