// ignore_for_file: use_build_context_synchronously

import 'package:easy_home/services/cloud/fcm_token_service.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificaionTestVeiw extends StatefulWidget {
  const NotificaionTestVeiw({super.key});

  @override
  State<NotificaionTestVeiw> createState() => _NotificaionTestVeiwState();
}

class _NotificaionTestVeiwState extends State<NotificaionTestVeiw> {
  late final TextEditingController text;
  late final TextEditingController text2;
  late final size = Screen(MediaQuery.of(context).size);

  bool isLoading = false;
  @override
  void initState() {
    text = TextEditingController();
    text2 = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    text2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing token"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.hp(10),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50.0),
                    const Text("Firbase fcm token"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: text,
                      maxLength: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String? fcmToken =
                            await FirebaseMessaging.instance.getToken();
                        setState(() {
                          text.text = fcmToken!;
                        });
                      },
                      child: const Text("Get Fcm Token"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Firbase bearer token"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: text2,
                      maxLength: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String? fcmToken =
                            await FCMService().unifyGenerateToken();
                        setState(() {
                          text2.text = fcmToken;
                        });
                      },
                      child: const Text("Get bearer Token"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // FCMService().unifySendNotification();
                      },
                      child: const Text("Send Testing Notification"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
