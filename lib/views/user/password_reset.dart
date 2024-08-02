// ignore_for_file: use_build_context_synchronously

import 'package:easy_home/utilities/dialogs/error_dialog.dart';
import 'package:easy_home/utilities/ui/clippers.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetVeiw extends StatefulWidget {
  const PasswordResetVeiw({super.key});

  @override
  State<PasswordResetVeiw> createState() => _PasswordResetVeiwState();
}

class _PasswordResetVeiwState extends State<PasswordResetVeiw> {
  late final TextEditingController email;
  late final size = Screen(MediaQuery.of(context).size);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  @override
  void initState() {
    email = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    email.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    width: double.infinity,
                    height: size.hp(37),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).secondaryHeaderColor,
                          Theme.of(context).secondaryHeaderColor
                        ],
                      ),
                    ),
                    child: const Column(),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    width: double.infinity,
                    height: size.hp(37),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).secondaryHeaderColor,
                          Theme.of(context).secondaryHeaderColor
                        ],
                      ),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper1(),
                  child: Container(
                    width: double.infinity,
                    height: size.hp(37),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor
                    ])),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.hp(4),
                        ),
                        Image.asset('assets/logo_inverted_transperant.png',
                            alignment: Alignment.center,
                            width: size.wp(30),
                            height: size.wp(30)),
                        const SizedBox(
                          height: 0,
                        ),
                        Text(
                          "Easy Home",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: size.hp(4)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.hp(10),
            ),
            Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const SizedBox(height: 50.0),
                      const Text(
                        'Enter your email address to reset your password:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: true,
                        decoration: const InputDecoration(
                            hintText: 'Enter Email Address',
                            label: Text('Email Address'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton.icon(
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
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                email: email.text,
                                // actionCodeSettings: ActionCodeSettings(url: ),
                              );
                              showSuccessNotification(
                                context,
                                "Password reset email sent to ${email.text} ",
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "auth/invalid-email") {
                                await showErrorDialog(
                                  context,
                                  "Invalid email address",
                                );
                              } else if (e.code == "user-not-found") {
                                await showErrorDialog(
                                  context,
                                  "Email address not found",
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.lock_reset),
                        label: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Login'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
