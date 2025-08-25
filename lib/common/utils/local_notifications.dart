import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "test",
          "test channel",
          channelDescription: "this is our channel",
          importance: Importance.max,
          playSound: true,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(),
      );
      await _notificationsPlugin.show(id, message.notification!.title, message.notification!.body, notificationDetails);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
