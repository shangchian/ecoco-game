import 'dart:developer';
import '../services/interface/i_points_service.dart';
import '../models/recycling_period_stats.dart';

/// Repository for recycling statistics data
class RecyclingRepository {
  static const String recyclingStatsKey = 'recyclingStats';
  final IPointsService _pointsService;

  RecyclingRepository({required IPointsService pointsService})
      : _pointsService = pointsService;

  /// Fetch recycling stats from API and convert to three period-specific stats
  /// Returns monthly, yearly, and total stats in a single object
  Future<RecyclingStatsData> fetchRecyclingStats() async {
    try {
      final response = await _pointsService.getRecyclingStats();

      return RecyclingStatsData(
        monthly: RecyclingPeriodStats.fromApiResponse(
          response,
          StatsPeriod.monthly,
        ),
        yearly: RecyclingPeriodStats.fromApiResponse(
          response,
          StatsPeriod.yearly,
        ),
        total: RecyclingPeriodStats.fromApiResponse(
          response,
          StatsPeriod.total,
        ),
      );
    } catch (e) {
      log('Error fetching recycling stats: $e');
      rethrow;
    }
  }
}

/// Container for three period-specific recycling stats
class RecyclingStatsData {
  final RecyclingPeriodStats monthly;
  final RecyclingPeriodStats yearly;
  final RecyclingPeriodStats total;

  const RecyclingStatsData({
    required this.monthly,
    required this.yearly,
    required this.total,
  });
}
