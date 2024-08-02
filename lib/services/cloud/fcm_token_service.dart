import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:unify_fcm/unify_fcm.dart';

class FCMService {
  String? token;

  // Function to get the FCM token and store it in Firestore
  Future<void> storeFCMToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await updateUserToken(fcmToken);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error:  $e ");
      }
    }
  }

  // Function to update the FCM token in Firestore
  Future<void> updateUserToken(String token) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await userRef.update({
          'fcmToken': token,
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint("Error:  $e ");
      }
    }
  }

  // Function to handle token refresh
  void handleTokenRefresh() {
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await updateUserToken(newToken);
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error:  $e ");
      }
    }
  }

  Future<void> unifyInitialize() async {
    token = await unifyGenerateToken();
    UnifyServices.initUnify(
      config: UnifyConfig(
        fcmAccessToken: token!,
        projectName: projectName,
      ),
    );
  }

  Future<String> unifyGenerateToken() async {
    try {
      token = await UnifyServices.genTokenFromServiceAcc(
          serviceAccount: servceAccount);
      return token!;
    } on Exception catch (e) {
      return "error $e";
    }
  }

  void unifySendNotification({
    required String fcmToken,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    try {
      String? id = await UnifyServices.sendNotification(
        notification: UnifyNoficationModel(
          // topic: "testing",
          token: fcmToken,
          notifyId: "1",
          title: title,
          body: body,
          imageUrl: imageUrl,
        ),
      );
      debugPrint("Message id: $id");
    } on Exception catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
    }
  }
}
