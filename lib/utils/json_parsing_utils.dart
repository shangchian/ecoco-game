import 'dart:convert';
import '../flavors.dart';

/// Custom exception for JSON parsing errors with detailed context
class JsonParsingException implements Exception {
  final String context;
  final String errorType;
  final String? fieldPath;
  final String? jsonSnippet;
  final dynamic originalError;

  JsonParsingException({
    required this.context,
    required this.errorType,
    this.fieldPath,
    this.jsonSnippet,
    this.originalError,
  });

  @override
  String toString() {
    final buffer = StringBuffer();

    // Always include context and error type
    buffer.write('JSON parsing failed in $context: $errorType');

    // Add field path if available
    if (fieldPath != null) {
      buffer.write(' at field "$fieldPath"');
    }

    // Include original error message
    if (originalError != null) {
      buffer.write('\nOriginal error: $originalError');
    }

    // In internal flavor, include JSON snippet for debugging
    if (F.appFlavor == Flavor.internal && jsonSnippet != null) {
      buffer.write('\nJSON snippet:\n$jsonSnippet');
    }

    return buffer.toString();
  }
}

/// Parses JSON with contextual error information
///
/// Wraps a JSON parsing operation and provides detailed error context
/// if parsing fails. Useful for debugging production issues.
///
/// Type parameter T: The type being parsed
///
/// Parameters:
///   - parser: Function that performs the actual parsing
///   - context: Human-readable description of what's being parsed
///   - jsonSnippet: Optional JSON object to include in error (limited size)
///
/// Throws: JsonParsingException with detailed context on parse failure
T parseWithContext<T>({
  required T Function() parser,
  required String context,
  Map<String, dynamic>? jsonSnippet,
}) {
  try {
    return parser();
  } on TypeError catch (e) {
    throw JsonParsingException(
      context: context,
      errorType: 'TypeError',
      fieldPath: _extractFieldFromError(e),
      jsonSnippet: _formatJsonSnippet(jsonSnippet),
      originalError: e,
    );
  } on FormatException catch (e) {
    throw JsonParsingException(
      context: context,
      errorType: 'FormatException',
      fieldPath: _extractFieldFromError(e),
      jsonSnippet: _formatJsonSnippet(jsonSnippet),
      originalError: e,
    );
  } on StateError catch (e) {
    // Common for enum decode failures
    throw JsonParsingException(
      context: context,
      errorType: 'StateError',
      fieldPath: _extractFieldFromError(e),
      jsonSnippet: _formatJsonSnippet(jsonSnippet),
      originalError: e,
    );
  } on ArgumentError catch (e) {
    // Common for null/required field errors
    throw JsonParsingException(
      context: context,
      errorType: 'ArgumentError',
      fieldPath: _extractFieldFromError(e),
      jsonSnippet: _formatJsonSnippet(jsonSnippet),
      originalError: e,
    );
  } catch (e) {
    // Catch-all for other errors
    throw JsonParsingException(
      context: context,
      errorType: e.runtimeType.toString(),
      fieldPath: _extractFieldFromError(e),
      jsonSnippet: _formatJsonSnippet(jsonSnippet),
      originalError: e,
    );
  }
}

/// Parses a JSON array with index tracking for error reporting
///
/// Wraps parsing of each array item and provides the index of any
/// item that fails to parse.
///
/// Type parameter T: The type of items in the list
///
/// Parameters:
///   - jsonList: The JSON array to parse
///   - itemParser: Function to parse each item
///   - context: Base context (will be appended with index on error)
///
/// Throws: JsonParsingException with index information on failure
List<T> parseListWithContext<T>({
  required List<dynamic> jsonList,
  required T Function(Map<String, dynamic>) itemParser,
  required String context,
}) {
  final results = <T>[];

  for (int i = 0; i < jsonList.length; i++) {
    try {
      final item = jsonList[i];
      if (item is! Map<String, dynamic>) {
        throw FormatException(
            'Expected Map<String, dynamic> but got ${item.runtimeType}');
      }

      results.add(parseWithContext<T>(
        parser: () => itemParser(item),
        context: '$context[$i]',
        jsonSnippet: item,
      ));
    } catch (e) {
      // Re-throw with index context if it's already a JsonParsingException
      if (e is JsonParsingException) {
        rethrow;
      }

      // Otherwise create new exception with index
      throw JsonParsingException(
        context: '$context[$i]',
        errorType: e.runtimeType.toString(),
        fieldPath: null,
        jsonSnippet: _formatJsonSnippet(
            jsonList[i] is Map<String, dynamic> ? jsonList[i] : null),
        originalError: e,
      );
    }
  }

  return results;
}

/// Extracts field name from error messages
///
/// Attempts to parse error messages to extract the specific field
/// that caused the parsing failure.
String? _extractFieldFromError(dynamic error) {
  final errorString = error.toString();

  // Common patterns in json_serializable and Dart errors:
  // "type 'String' is not a subtype of type 'int' of 'pointsChange'"
  // "Invalid argument(s): Must not be null: logId"
  // "Bad state: No element" (enum decode)

  // Pattern 1: Type mismatch with field name at end
  final typeErrorPattern = RegExp(r"of '(\w+)'");
  final typeMatch = typeErrorPattern.firstMatch(errorString);
  if (typeMatch != null) {
    return typeMatch.group(1);
  }

  // Pattern 2: Null check with field name
  final nullPattern = RegExp(r"Must not be null: (\w+)");
  final nullMatch = nullPattern.firstMatch(errorString);
  if (nullMatch != null) {
    return nullMatch.group(1);
  }

  // Pattern 3: json_annotation CheckedFromJsonException
  if (errorString.contains('Could not deserialize')) {
    final fieldPattern = RegExp(r"field '(\w+)'");
    final fieldMatch = fieldPattern.firstMatch(errorString);
    if (fieldMatch != null) {
      return fieldMatch.group(1);
    }
  }

  // Pattern 4: Required parameter error
  final requiredPattern = RegExp(r"Required named parameter '(\w+)'");
  final requiredMatch = requiredPattern.firstMatch(errorString);
  if (requiredMatch != null) {
    return requiredMatch.group(1);
  }

  return null; // Could not extract field name
}

/// Formats JSON snippet for error messages
///
/// Limits size and redacts sensitive information for safe logging.
/// More verbose in internal flavor, minimal in production.
String? _formatJsonSnippet(Map<String, dynamic>? json) {
  if (json == null) return null;

  // In production flavor, don't include JSON snippets
  // (they might contain sensitive data)
  if (F.appFlavor == Flavor.production) {
    return null;
  }

  try {
    // Create a copy to avoid modifying original
    final safeCopy = Map<String, dynamic>.from(json);

    // Redact potentially sensitive fields
    final sensitiveFields = ['token', 'password', 'email', 'phone'];
    for (final field in sensitiveFields) {
      if (safeCopy.containsKey(field)) {
        safeCopy[field] = '***REDACTED***';
      }
    }

    // Convert to formatted JSON
    String jsonString = const JsonEncoder.withIndent('  ').convert(safeCopy);

    // Limit length to prevent log overflow
    const maxLength = 500;
    if (jsonString.length > maxLength) {
      jsonString = '${jsonString.substring(0, maxLength)}... (truncated)';
    }

    return jsonString;
  } catch (e) {
    return null; // Failed to format, skip
  }
}

/// Safely parse 'code' from response data which might be int or String
/// Returns -1 if code is missing or invalid
int parseResponseCode(dynamic data) {
  if (data is Map) {
    final dynamic raw = data['code'];
    if (raw is int) {
      return raw;
    }
    if (raw is String) {
      return int.tryParse(raw) ?? -1;
    }
  }
  return -1;
}
