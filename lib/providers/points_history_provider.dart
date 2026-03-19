import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/points_log_model.dart';
import '/providers/auth_provider.dart';
import '../repositories/points_repository.dart';

part 'points_history_provider.g.dart';

/// Immutable state class for points history
class PointsHistoryState {
  final List<PointLog> allLogs;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const PointsHistoryState({
    this.allLogs = const [],
    this.currentPage = 1,
    this.hasMore = false, // Default false for offline-first as we show all
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  /// Copy with method for immutable updates
  PointsHistoryState copyWith({
    List<PointLog>? allLogs,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
    bool clearError = false,
  }) {
    return PointsHistoryState(
      allLogs: allLogs ?? this.allLogs,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Filter helper: Get only earned logs
  List<PointLog> get earnedLogs =>
      allLogs.where((log) => log.logType == LogType.earned).toList();

  /// Filter helper: Get only used logs
  List<PointLog> get usedLogs =>
      allLogs.where((log) => log.logType == LogType.used).toList();
}

/// Points history provider with state management
@riverpod
class PointsHistoryNotifier extends _$PointsHistoryNotifier {
  @override
  PointsHistoryState build() {
    final repository = ref.watch(pointsRepositoryProvider);
    
    // Subscribe to the local database stream
    final sub = repository.watchLogs().listen((logs) {
      state = state.copyWith(
        allLogs: logs,
        hasMore: false, // Local DB shows all available history
        lastUpdated: DateTime.now().toUtc(),
      );
    });
    
    // Cancel subscription when provider is disposed
    ref.onDispose(sub.cancel);
    
    return const PointsHistoryState(isLoading: true);
  }

  /// Sync data with server
  Future<void> fetchInitialData() async {
    // Only show loading if we have no data yet
    if (state.allLogs.isEmpty) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      await ref.read(pointsRepositoryProvider).sync();
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    } on NotAuthenticatedException {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Authentication required',
        );
      }
    } on TokenRefreshFailedException {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Token refresh failed',
        );
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// Load more data - Not needed for offline-first as we sync all history
  /// Keeping method signature for compatibility if needed, but it just triggers sync
  Future<void> loadMore() async {
    await fetchInitialData();
  }

  /// Refresh data
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await fetchInitialData();
  }

  /// Clear all data
  Future<void> clear() async {
    await ref.read(pointsRepositoryProvider).clear();
    state = const PointsHistoryState();
  }
}

