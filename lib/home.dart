import 'package:easy_home/views/user/user_detail_update_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'services/auth/auth_service.dart';
import 'views/email_verify.dart';
import 'views/welcome_screen_view.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return const WelcomeScreen();
            }
            if (!user.emailVerified) {
              return const EmailVerifyView();
            } else {
              return const UserDetailsUpdatePage();
            }

          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
        }
      },
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
