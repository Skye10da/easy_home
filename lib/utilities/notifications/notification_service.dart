import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
      

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@drawable/ic_launcher'); // Replace with your icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // static Future<void> showNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'channel_id',
  //     'channel_name',
  //     channelDescription: "Welcome to easy home",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   await _notificationsPlugin.show(0, title, body, notificationDetails);
  // }
  static Future<void> showRemoteNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '0',
      'notification',
      channelDescription: "Welcome to easy home",
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      // payload: 'Notification Payload',
    );
  }
}
