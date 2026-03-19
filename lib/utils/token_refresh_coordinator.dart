import 'dart:async';
import '/models/auth_data_model.dart';

/// Coordinator to synchronize token refresh operations across the app.
/// Prevents multiple components (TokenManager, Interceptors) from refreshing simultaneously.
class TokenRefreshCoordinator {
  static final TokenRefreshCoordinator _instance = TokenRefreshCoordinator._internal();
  
  factory TokenRefreshCoordinator() => _instance;
  
  TokenRefreshCoordinator._internal();

  Completer<AuthData>? _refreshCompleter;

  /// Check if a refresh operation is currently in progress
  bool get isRefreshing => _refreshCompleter != null && !_refreshCompleter!.isCompleted;

  /// Wait for the current refresh operation to complete (if any)
  Future<AuthData?> waitForRefresh() async {
    if (_refreshCompleter != null) {
      try {
        return await _refreshCompleter!.future;
      } catch (e) {
        // If the ongoing refresh fails, we propagate the error or return null
        return null; 
      }
    }
    return null;
  }

  /// Start a lock for refresh operation
  /// Returns existing future if already refreshing, or null if lock acquired successfully
  Future<AuthData>? preRefreshCheck() {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      return _refreshCompleter!.future;
    }
    // Lock acquired
    _refreshCompleter = Completer<AuthData>();
    return null;
  }

  /// Complete the refresh operation successfully
  void onSuccess(AuthData newData) {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _refreshCompleter!.complete(newData);
    }
    _refreshCompleter = null;
  }

  /// Complete the refresh operation with failure
  void onError(Object error) {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _refreshCompleter!.completeError(error);
    }
    _refreshCompleter = null;
  }
}
