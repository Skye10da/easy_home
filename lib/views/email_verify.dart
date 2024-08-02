// ignore_for_file: use_build_context_synchronously
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/constant/routes.dart';
import '/services/auth/auth_service.dart';
import '/utilities/dialogs/email_verify_dialog.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({
    super.key,
  });

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  bool loading = false;
  String message = "Have you verify your account";
  String? email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    final size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/sent-mail.png",
              width: size.wp(100),
            ),
            Text(
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                "Verification message has been sent to your email: $email"),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: const Text("Email verification message"),
                      content: const Text(
                          "New verification message sent, kindly check your email"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Ok"))
                      ],
                    );
                  },
                );
              },
              child: const Text("Havent received verification message? retry "),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(5.0),
                animationDuration: const Duration(seconds: 2),
                enableFeedback: true,
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: size.getWidthPx(10),
                    horizontal: size.getWidthPx(130),
                  ),
                ),
              ),
              onPressed: () {
                Future.delayed(
                  const Duration(seconds: 2),
                  () async {
                    emailVerifyDialog(context, loading, message);
                  },
                );
              },
              child: const Text("Proceed"),
            ),
            const SizedBox(
              height: 100,
            ),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().delete();
                  Navigator.pushNamedAndRemoveUntil(
                      context, welcomeRoute, (_) => false);
                },
                child: const Text("Wrong Email Address ? Get back"))
          ],
        ),
      ),
    );
  }
}
