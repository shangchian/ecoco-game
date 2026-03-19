import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// Debug logging interceptor that logs all HTTP requests and responses
/// Only enabled in internal/development flavor
class DebugLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final url = '${options.baseUrl}${options.path}';
    final headers = options.headers;
    final body = options.data;

    // Build log message
    final logMessage = StringBuffer();
    logMessage.writeln('>>> REQUEST');
    logMessage.writeln('Method: $method');
    logMessage.writeln('URL: $url');
    logMessage.writeln('Headers: $headers');
    logMessage.writeln('Body: ${_formatBody(body)}');

    developer.log(
      logMessage.toString(),
      name: 'Dio',
      time: DateTime.now(),
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    final body = response.data;

    // Build log message
    final logMessage = StringBuffer();
    logMessage.writeln('<<< RESPONSE (Status: $statusCode)');
    logMessage.writeln('Body: ${_formatBody(body)}');

    developer.log(
      logMessage.toString(),
      name: 'Dio',
      time: DateTime.now(),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final logMessage = StringBuffer();
    logMessage.writeln('!!! ERROR');
    logMessage.writeln('Type: ${err.type}');
    logMessage.writeln('Message: ${err.message}');
    if (err.response != null) {
      logMessage.writeln('Status: ${err.response?.statusCode}');
      logMessage.writeln('Response: ${_formatBody(err.response?.data)}');
    }

    developer.log(
      logMessage.toString(),
      name: 'Dio',
      level: 1000, // Warning level
      time: DateTime.now(),
    );

    handler.next(err);
  }

  /// Format body for logging
  /// If body is a Map, format as indented JSON for readability
  String _formatBody(dynamic body) {
    if (body == null) return 'null';

    if (body is Map || body is List) {
      try {
        // Format as indented JSON
        return const JsonEncoder.withIndent('  ').convert(body);
      } catch (e) {
        // If JSON encoding fails, return toString
        return body.toString();
      }
    }

    return body.toString();
  }
}
