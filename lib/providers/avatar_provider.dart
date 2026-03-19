import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/utils/image_tools.dart';
import '/states/avatar_state.dart';

part 'avatar_provider.g.dart';

@riverpod
class AvatarNotifier extends _$AvatarNotifier {
  @override
  AvatarState build() => const AvatarState();

  Future<void> loadAvatar(String? avatarUrl) async {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      state = state.copyWith(error: 'No avatar URL');
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final bytes = await ImageTools.downloadImage(avatarUrl);
      state = state.copyWith(
        imageBytes: bytes,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const AvatarState();
  }
}
