import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:teacher_panel/core/utils/app_logger.dart';

class NotificationService {
  Future<void> sendFcmHttpV1Notification({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    try {
      // Step 1: Load service account JSON
      final serviceAccountJsonStr =
      await rootBundle.loadString('assets/service-account.json');
      AppLogger.logInfo('🔑 Loaded service-account.json');

      final serviceAccountMap = jsonDecode(serviceAccountJsonStr);
      final projectId = serviceAccountMap['project_id'];
      AppLogger.logInfo('📦 Project ID: $projectId');

      // Step 2: Create credentials
      final serviceAccount =
      ServiceAccountCredentials.fromJson(serviceAccountJsonStr);
      AppLogger.logInfo('🔐 Created service account credentials');

      // Step 3: Authenticate with required scopes
      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final authClient = await clientViaServiceAccount(serviceAccount, scopes);
      AppLogger.logInfo('🔓 Authenticated successfully');

      // Step 4: Build request
      final url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

      final message = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "android": {
            "priority": "high",
          },
          "apns": {
            "headers": {"apns-priority": "10"},
            "payload": {
              "aps": {
                "sound": "default",
              }
            }
          }
        }
      };

      // Step 5: Send POST request
      final response = await authClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message),
      );

      AppLogger.logInfo('✅ Status: ${response.statusCode}');
      AppLogger.logInfo('📨 Response: ${response.body}');

      // Close the client
      authClient.close();

      // Check for non-success status
      if (response.statusCode != 200) {
        AppLogger.logError(
          '❌ Failed to send notification. Status code: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception('Notification send failed');
      }
    } catch (e, stacktrace) {
      AppLogger.logError('🚨 Exception sending notification: $e');
      AppLogger.logError('📚 Stacktrace:\n$stacktrace');
      rethrow; // if you want to handle it further up
    }
  }
}
