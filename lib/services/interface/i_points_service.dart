import '/models/auth_data_model.dart';
import '/models/points_history_model.dart';
import '/models/points_log_model.dart';
import '/models/wallet_model.dart';
import '/models/recycling_stats_response.dart';

/// Interface for Points Service
/// Implemented by both real and mock services
abstract class IPointsService {
  /// Get points history with pagination (legacy)
  /// [page] starts from 1
  Future<List<PointsHistory>> getPointsHistory(AuthData authData, {int page = 1});

  /// Get member points history (GET /app/member/points/history)
  /// Uses Bearer token authentication (modern pattern)
  /// [token] - Access token for authentication
  /// [page] - Page number (default 1)
  /// [limit] - Items per page (default 100)
  /// [updatedSince] - ISO 8601 UTC for incremental sync (optional)
  /// Returns points history with detailed transaction information
  Future<PointsHistoryResponse> getMemberPointsHistory({
    int page = 1,
    int limit = 100,
    String? updatedSince,
  });

  /// Get member wallet/points (GET /member/points)
  /// Uses Bearer token authentication (modern pattern)
  /// [token] - Access token for authentication
  /// [currencyCode] - Optional filter: 'ECOCO_POINT' or 'DAKA' (null = fetch all)
  Future<WalletData> getMemberPoints({String? currencyCode});

  /// Get recycling statistics (GET /member/recycling/stats)
  /// Uses Bearer token authentication
  /// [token] - Access token for authentication
  /// Returns recycling item counts and carbon reduction metrics
  Future<RecyclingStatsResponse> getRecyclingStats();
}
