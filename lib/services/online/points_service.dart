import 'dart:developer';

import '/models/auth_data_model.dart';
import '/models/points_history_model.dart';
import '/models/points_log_model.dart';
import '/models/wallet_model.dart';
import '/models/recycling_stats_response.dart';
import '/utils/json_parsing_utils.dart';
import 'base_service.dart';
import '/services/interface/i_points_service.dart';

class PointsService extends BaseService implements IPointsService {
  PointsService({
    super.onTokenRefreshed,
    super.onRefreshFailed,
  });

  @override
  Future<List<PointsHistory>> getPointsHistory(AuthData authData,
      {int page = 1}) async {
    try {
      if (page < 1) page = 1; // 從第一夜開始撈資料
      final response = await dio.post('/points/get-log', data: {
        "token": authData.accessToken,
        "page": page,
      });
      validateResponse(response);
      // 取得的資料是 transaction_at DESC
      return (response.data['dataResult'] as List)
          .map((json) => PointsHistory.fromJson(json))
          .toList();
    } catch (e) {
      log('Error getting points history: $e');
      throw handleError(e);
    }
  }

  @override
  Future<PointsHistoryResponse> getMemberPointsHistory({
    int page = 1,
    int limit = 100,
    String? updatedSince,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (updatedSince != null) {
        queryParams['updated_since'] = updatedSince;
      }

      // Use GET with Bearer token (modern pattern)
      final response = await dio.get(
        '/member/points/history',
        queryParameters: queryParams,
      );

      validateResponse(response);

      // Parse response with detailed error context
      return parseWithContext<PointsHistoryResponse>(
        parser: () {
          final dynamic resultData = response.data['result'];

          // Handle case where result is a List (e.g. empty list [] or direct list of logs)
          if (resultData is List) {
            if (resultData.isEmpty) {
              return const PointsHistoryResponse(pointLogs: []);
            }
            // Try to parse as direct list of PointLog
            // This handles if API returns [log1, log2] instead of { pointLogs: [...] }
            return PointsHistoryResponse(
              pointLogs: parseListWithContext<PointLog>(
                jsonList: resultData,
                itemParser: (json) => PointLog.fromJson(json),
                context: 'PointsHistoryResponse (direct list)',
              ),
            );
          }

          final result = resultData as Map<String, dynamic>;

          // Parse pointLogs array with index tracking
          final pointLogsJson = result['pointLogs'] as List<dynamic>;
          final pointLogs = parseListWithContext<PointLog>(
            jsonList: pointLogsJson,
            itemParser: (json) => PointLog.fromJson(json),
            context: 'PointsHistoryResponse.pointLogs',
          );

          return PointsHistoryResponse(pointLogs: pointLogs);
        },
        context: 'getMemberPointsHistory',
        jsonSnippet: response.data['result'],
      );
    } catch (e) {
      if (e is JsonParsingException) {
        log('Error parsing member points history: ${e.toString()}',
            name: 'PointsService');
      } else {
        log('Error getting member points history: $e', name: 'PointsService');
      }
      throw handleError(e);
    }
  }

  @override
  Future<WalletData> getMemberPoints({String? currencyCode}) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (currencyCode != null) {
        queryParams['currency-code'] = currencyCode;
      }

      // Use GET with Bearer token (modern pattern like /member/profile)
      final response = await dio.get(
        '/member/points',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      validateResponse(response);

      final dynamic resultData = response.data['result'];
      // Handle edge case where API returns [] or null instead of {}
      if (resultData is List || resultData == null) {
        return const WalletData(memberId: "0", wallets: []);
      }

      return WalletData.fromJson(resultData);
    } catch (e) {
      log('Error getting member points: $e');
      throw handleError(e);
    }
  }

  @override
  Future<RecyclingStatsResponse> getRecyclingStats() async {
    try {
      final response = await dio.get(
        '/member/recycling/stats',
      );

      validateResponse(response);
      return RecyclingStatsResponse.fromJson(response.data['result']);
    } catch (e) {
      log('Error getting recycling stats: $e');
      throw handleError(e);
    }
  }
}
