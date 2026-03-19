import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Class to hold session-scoped state that should persist across navigation
class SessionState {
  /// Whether the home popup modal has been shown in this session
  bool hasShownHomePopup = false;
}

/// Provider for SessionState
final sessionStateProvider = Provider<SessionState>((ref) {
  return SessionState();
});
