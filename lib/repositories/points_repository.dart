import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../models/points_log_model.dart';
import '../services/interface/i_points_service.dart';
import '../providers/points_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_database_provider.dart';

part 'points_repository.g.dart';

@Riverpod(keepAlive: true)
PointsRepository pointsRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(pointsServiceProvider);
  return PointsRepository(db, api);
}

class PointsRepository {
  final AppDatabase _db;
  final IPointsService _api;

  PointsRepository(this._db, this._api);

  /// Watch local database for changes
  Stream<List<PointLog>> watchLogs() {
    return _db.watchPointLogs();
  }

  /// Syncs local database with remote API using incremental updates
  Future<void> sync() async {
    try {
      // 1. Get Anchor (Latest lastUpdatedAt from local DB)
      final lastUpdated = await _db.getLatestLastUpdatedAt();
      
      // Ensure we use the exact string format the API expects if needed, 
      // but ISO8601 is standard.
      final updatedSince = lastUpdated?.toIso8601String();

      // 2. Fetch Diff Loop
      int page = 1;
      const limit = 100;
      bool hasMore = true;

      while (hasMore) {
        final response = await _api.getMemberPointsHistory(
          page: page,
          limit: limit,
          updatedSince: updatedSince,
        );

        // 3. Upsert to Local DB
        if (response.pointLogs.isNotEmpty) {
          await _db.upsertPointLogs(response.pointLogs);
        }

        // 4. Check Pagination
        // If we received fewer items than the limit, we've reached the end.
        if (response.pointLogs.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      }

      // 5. Prune (Optional) - Keep 13 months of history
      // This prevents the local DB from growing indefinitely.
      final thirteenMonthsAgo = DateTime.now().subtract(const Duration(days: 395)); // Approx 13 months
      await _db.pruneOldLogs(thirteenMonthsAgo);

    } catch (e) {
      if (e is NotAuthenticatedException) {
        return;
      }
      // Handle sync errors (e.g. network issues)
      // We might want to rethrow or log, but since this is often background/void,
      // rethrowing allows the UI to show a snackbar or error state if it's explicitly waiting.
      rethrow;
    }
  }
  
  Future<void> clear() async {
      await _db.clearAll();
  }
}
