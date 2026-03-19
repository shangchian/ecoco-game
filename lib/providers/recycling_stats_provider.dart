import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/recycling_repository.dart';
import '../providers/auth_provider.dart';
import '../providers/points_provider.dart';

part 'recycling_stats_provider.g.dart';

@Riverpod(keepAlive: true)
class RecyclingStats extends _$RecyclingStats {
  RecyclingRepository? _repository;

  RecyclingRepository get repository {
    _repository ??= RecyclingRepository(
      pointsService: ref.read(pointsServiceProvider),
    );
    return _repository!;
  }

  @override
  RecyclingStatsData? build() => null;

  /// Fetch recycling statistics from API
  /// Uses automatic token refresh through authProvider
  Future<void> fetchRecyclingStats() async {
    try {
      final stats = await repository.fetchRecyclingStats();

      if (ref.mounted) {
        state = stats;
      }
    } on NotAuthenticatedException {
      if (ref.mounted) {
        state = null;
      }
    } on TokenRefreshFailedException {
      if (ref.mounted) {
        state = null;
      }
    } catch (e) {
      // Log error but don't update state
      // This allows existing data to remain visible
      // ignore: avoid_print
      print('Error fetching recycling stats: $e');
      rethrow;
    }
  }

  /// Clear the recycling stats (e.g., on logout)
  void clear() {
    state = null;
  }
}
