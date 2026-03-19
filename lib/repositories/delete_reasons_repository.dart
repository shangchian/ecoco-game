import 'dart:developer';
import '/models/member_delete_reason_model.dart';
import '/services/interface/i_delete_reasons_service.dart';
import '/services/member_delete_reasons_service.dart';

/// Repository for managing delete reasons data
/// Wraps the service layer to provide a consistent repository pattern
class DeleteReasonsRepository {
  final IDeleteReasonsService _deleteReasonsService;

  DeleteReasonsRepository({IDeleteReasonsService? deleteReasonsService})
      : _deleteReasonsService =
            deleteReasonsService ?? MemberDeleteReasonsService();

  /// Get delete reasons list
  /// The service already handles caching internally
  Future<List<DeleteReasonKind>> getDeleteReasons({
    bool forceRefresh = false,
  }) async {
    try {
      final response = await _deleteReasonsService.getDeleteReasons();
      log('Got ${response.result.length} delete reason kinds');
      return response.result;
    } catch (e) {
      log('Error in getDeleteReasons: $e');
      rethrow;
    }
  }

  /// Clear delete reasons cache
  /// Note: The current service implementation manages its own cache
  /// This method is here for consistency with the repository pattern
  Future<void> clearDeleteReasonsCache() async {
    try {
      await _deleteReasonsService.clearCache();
    } catch (e) {
      log('Error clearing delete reasons cache: $e');
    }
  }
}
