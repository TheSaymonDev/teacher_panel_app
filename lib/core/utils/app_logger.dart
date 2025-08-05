import 'package:flutter/foundation.dart';

class AppLogger {

  /// Log an error message (level: ERROR)
  static void logError(dynamic message) {
    if (kDebugMode) {
      print('⛔ ERROR: $message');
    }
  }

  /// Log an informational message (level: INFO)
  static void logInfo(dynamic message) {
    if (kDebugMode) {
      print('ℹ️INFO: $message');
    }
  }

  /// Log a debug message (level: DEBUG)
  static void logDebug(dynamic message) {
    if (kDebugMode) {
      print('🐛 DEBUG: $message');
    }
  }
}
