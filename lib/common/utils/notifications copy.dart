import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../consts/app_keys.dart';
import 'local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize Firebase and set up message handlers
  Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // // Request notification permissions for iOS
    // await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

    // // Set foreground notification presentation options for iOS
    // await _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    // Handle messages that are opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Print the token each time the application loads
    String token = await getToken();
    HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.fbToken, value: token);
  }

  /// This handler must be a top-level function
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  /// Get the FCM token for this device
  Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken() ?? "";
    HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.fbToken, value: token);
    return token;
  }
}
