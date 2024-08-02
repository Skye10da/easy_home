import 'package:easy_home/services/auth/auth_service.dart';
import 'package:easy_home/utilities/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._privateConstructor();

  static final FirebaseMessagingService instance =
      FirebaseMessagingService._privateConstructor();

  Future<void> initialize() async {
    // Ensure Firebase is initialized
    await AuthService.firebase().initialize();
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showRemoteNotification(
        message,
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Set up message opened app handler
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await AuthService.firebase().initialize();
    NotificationService.showRemoteNotification(message);
  }

  // void sendMessage(RemoteMessage message) {
  //   FirebaseMessaging.instance;
  // }
}
