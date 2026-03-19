
class AvatarState {
  final List<int>? imageBytes;
  final bool isLoading;
  final String? error;

  const AvatarState({
    this.imageBytes,
    this.isLoading = false,
    this.error,
  });

  AvatarState copyWith({
    List<int>? imageBytes,
    bool? isLoading,
    String? error,
  }) {
    return AvatarState(
      imageBytes: imageBytes ?? this.imageBytes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}