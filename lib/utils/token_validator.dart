/// Token validation utilities for checking token expiration
///
/// Provides methods to parse and validate access token expiration timestamps
class TokenValidator {
  /// Default buffer time before token expiry to trigger refresh (2 minutes)
  static const Duration defaultBuffer = Duration(minutes: 2);

  /// Check if token needs refresh based on expiration time
  ///
  /// Returns true if:
  /// - Token is already expired
  /// - Token will expire within the buffer time (default 2 minutes)
  /// - expiresAt is empty or invalid
  ///
  /// [expiresAt] ISO 8601 timestamp string (e.g., "2024-12-31T23:59:59Z")
  /// [buffer] Optional custom buffer duration (defaults to 2 minutes)
  static bool needsRefresh(String expiresAt, {Duration? buffer}) {
    if (expiresAt.isEmpty) return true;

    final expiryDateTime = parseExpiresAt(expiresAt);
    if (expiryDateTime == null) return true;

    final bufferTime = buffer ?? defaultBuffer;
    final now = DateTime.now();
    final threshold = expiryDateTime.subtract(bufferTime);

    // Need refresh if current time is past the threshold
    return now.isAfter(threshold);
  }

  /// Check if token is expired (past expiration time)
  ///
  /// Returns true if token is already expired or expiresAt is invalid
  static bool isTokenExpired(String expiresAt) {
    if (expiresAt.isEmpty) return true;

    final expiryDateTime = parseExpiresAt(expiresAt);
    if (expiryDateTime == null) return true;

    return DateTime.now().isAfter(expiryDateTime);
  }

  /// Check if token is expiring soon (within buffer time)
  ///
  /// Returns true if token will expire within the buffer time
  /// Does not return true if already expired
  ///
  /// [expiresAt] ISO 8601 timestamp string
  /// [buffer] Optional custom buffer duration (defaults to 2 minutes)
  static bool isTokenExpiringSoon(String expiresAt, {Duration? buffer}) {
    if (expiresAt.isEmpty) return false;

    final expiryDateTime = parseExpiresAt(expiresAt);
    if (expiryDateTime == null) return false;

    final bufferTime = buffer ?? defaultBuffer;
    final now = DateTime.now();
    final threshold = expiryDateTime.subtract(bufferTime);

    // Expiring soon if we're past threshold but not yet expired
    return now.isAfter(threshold) && now.isBefore(expiryDateTime);
  }

  /// Parse ISO 8601 timestamp string to DateTime
  ///
  /// Returns null if parsing fails or string is empty
  ///
  /// Handles formats like:
  /// - "2024-12-31T23:59:59Z"
  /// - "2024-12-31T23:59:59.123Z"
  /// - "2024-12-31T23:59:59+08:00"
  static DateTime? parseExpiresAt(String expiresAt) {
    if (expiresAt.isEmpty) return null;

    try {
      return DateTime.parse(expiresAt);
    } catch (e) {
      // Invalid format - return null
      return null;
    }
  }
}
