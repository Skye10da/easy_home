import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/services/cloud/fcm_token_service.dart';
import 'package:easy_home/services/model/notification_model.dart';
import 'package:easy_home/utilities/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> checkFollowStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    DocumentSnapshot currentUserDoc =
        await _db.collection('users').doc(targetUserId).get();
    List<dynamic> currentUserFollowing = currentUserDoc['followers'];
    // List<dynamic> targetUserFollowers = targetUserDoc['followers'];
    bool result = currentUserFollowing.contains(currentUserId);
    return result;
  }

  Future<void> followUnfollowUser({
    required String currentUserId,
    required String targetUserId,
    required bool isFollowing,
  }) async {
    try {
      if (isFollowing) {
        // Remove target user from the current user's following list
        await _db.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayRemove([targetUserId]),
        });

        // Remove current user from the target user's followers list
        await _db.collection('users').doc(targetUserId).update({
          'followers': FieldValue.arrayRemove([currentUserId]),
        });

        // checkFollowStatus(
        //     currentUserId: currentUserId, targetUserId: targetUserId);
      } else {
        DocumentSnapshot targetUserDoc =
            await _db.collection('users').doc(targetUserId).get();
        // Add target user to the current user's following list
        await _db.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayUnion([targetUserId]),
        });

        // Add current user to the target user's followers list
        await _db.collection('users').doc(targetUserId).update({
          'followers': FieldValue.arrayUnion([currentUserId]),
        });

        // checkFollowStatus(
        //     currentUserId: currentUserId, targetUserId: targetUserId);
        // Send notification to the target user via FCM
        String? targetUserFCMToken = targetUserDoc['fcmToken'];
        if (targetUserFCMToken != null) {
          FCMService().unifySendNotification(
            fcmToken: targetUserFCMToken,
            body: 'You have a new follower.',
            title: 'New Notification',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error following/unfollowing user: $e');
      }
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      // Add target user to the current user's following list
      await _db.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayUnion([targetUserId]),
      });

      // Add current user to the target user's followers list
      await _db.collection('users').doc(targetUserId).update({
        'followers': FieldValue.arrayUnion([currentUserId]),
      });

      // Send notification to the target user
      await sendNotification(
        userId: targetUserId,
        title: 'New Notification',
        message: 'You have a new follower.',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error following user: $e');
      }
    }
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    try {
      String notificationId = _db.collection('notifications').doc().id;
      NotificationModel notification = NotificationModel(
        id: notificationId,
        userId: userId,
        title: title,
        message: message,
        isRead: false,
        timestamp: DateTime.now(),
      );

      await _db
          .collection('notifications')
          .doc(notificationId)
          .set(notification.toJson());

      // Send notification
// FCMService().unifySendNotification(title: "New property", body: "New Property Posted by ${_ownerId}", fcmToken: );

      NotificationService.showRemoteNotification(RemoteMessage(
        notification: RemoteNotification(
          title: title,
          body: message,
        ),
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
    }
  }
}
