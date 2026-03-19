import '/models/member_delete_reason_model.dart';

/// Custom exception for delete reasons fetch errors
class DeleteReasonsFetchException implements Exception {
  final String message;
  DeleteReasonsFetchException(this.message);

  @override
  String toString() => message;
}

/// Interface for delete reasons service
abstract class IDeleteReasonsService {
  /// Get delete reasons from cache or fetch from S3
  /// Automatically handles caching based on Last-Modified header
  Future<DeleteReasonsResponse> getDeleteReasons();

  /// Clear any cached data
  Future<void> clearCache();
}
