import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/services/model/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
  });

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  late final String userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid;

    super.initState();
  }

  void _clearAllNotifications() async {
    var batch = FirebaseFirestore.instance.batch();
    var notifications = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              _clearAllNotifications();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var notifications = snapshot.data!.docs.map((doc) {
            return NotificationModel.fromJson(
                doc.data() as Map<String, dynamic>);
          }).toList();

          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications available.'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return ListTile(
                title: Text(
                  notification.title,
                  style: TextStyle(
                      color: notification.isRead
                          ? Theme.of(context).disabledColor
                          : null),
                ),
                subtitle: Text(
                  notification.message,
                  style: TextStyle(
                      color: notification.isRead
                          ? Theme.of(context).disabledColor
                          : null),
                ),
                trailing: IconButton(
                  icon: Icon(
                    notification.isRead ? Icons.check_circle : Icons.circle,
                    color: notification.isRead ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(notification.id)
                        .update({'isRead': true});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
