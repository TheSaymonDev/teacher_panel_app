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
    // ✅ Step 1: Read service account JSON from assets using rootBundle
    final serviceAccountJsonStr =
        await rootBundle.loadString('assets/service-account.json');
    final serviceAccountMap = jsonDecode(serviceAccountJsonStr);
    final projectId = serviceAccountMap['project_id'];

    // ✅ Step 2: Create credentials
    final serviceAccount =
        ServiceAccountCredentials.fromJson(serviceAccountJsonStr);

    // ✅ Step 3: Authenticate
    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final authClient = await clientViaServiceAccount(serviceAccount, scopes);

    // ✅ Step 4: Construct HTTP v1 request
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

    final response = await authClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message),
    );

    AppLogger.logInfo('✅ Status: ${response.statusCode}');
    AppLogger.logInfo('📨 Response: ${response.body}');

    authClient.close();
  }
}
