// Import the required package
// ignore_for_file: use_build_context_synchronously

import 'package:easy_home/services/auth/google_signin.dart';
import 'package:easy_home/services/cloud/fcm_token_service.dart';
import 'package:easy_home/utilities/ui/clippers.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:easy_home/views/user/password_reset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer' as devtools show log;

import '../constant/routes.dart';
import '../services/auth/auth_exception.dart';
import '../services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController email;
  late final TextEditingController password;
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showDialog = false;
  bool isVisible = true;
  bool _isLoading = false;
  bool _isLoadingG = false;
  String passwordStrength = '';
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasDigits = false;
  bool hasMinLength = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void evaluatePassword(String value) {
    setState(() {
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasLowercase = value.contains(RegExp(r'[a-z]'));
      hasDigits = value.contains(RegExp(r'\d'));
      hasMinLength = value.length >= 8;

      if (hasUppercase && hasLowercase && hasDigits && hasMinLength) {
        passwordStrength = 'Strong';
      } else if (hasUppercase || hasLowercase || hasDigits || hasMinLength) {
        passwordStrength = 'Medium';
      } else {
        passwordStrength = 'Weak';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Screen(MediaQuery.of(context).size);
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
                        gradient: LinearGradient(colors: [
                      Theme.of(context).secondaryHeaderColor,
                      Theme.of(context).secondaryHeaderColor
                    ])),
                    child: const Column(),
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
            Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Enter Your Login Information:',
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
                        autocorrect: false,
                        enableSuggestions: true,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [
                          AutofillHints.username,
                          AutofillHints.email,
                        ],
                        decoration: const InputDecoration(
                            hintText: 'Enter Email Address',
                            label: Text('Email Address'),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          return null;
                        },
                        onChanged: evaluatePassword,
                        controller: password,
                        autocorrect: false,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        textInputAction: TextInputAction.done,
                        obscureText: isVisible,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter password',
                          prefixIcon: const Icon(Icons.password),
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: isVisible
                                ? const Icon(
                                    Icons.visibility,
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                  ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Password Strength: $passwordStrength',
                        style: TextStyle(
                          color: passwordStrength == 'Strong'
                              ? Colors.green
                              : passwordStrength == 'Medium'
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Password must contain:\n'
                        ' - At least 8 characters\n'
                        ' - At least one uppercase letter\n'
                        ' - At least one lowercase letter\n'
                        ' - At least one number',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(5.0),
                          animationDuration: const Duration(seconds: 2),
                          enableFeedback: true,
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              vertical: size.hp(2),
                              horizontal: size.wp(30),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              var response =
                                  await AuthService.firebase().signIn(
                                email: email.text,
                                password: password.text,
                              );
                              await FCMService().storeFCMToken();
                              devtools.log(response.isEmailVerified.toString());
                              if (!response.isEmailVerified) {
                                displayDialog(context);
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, homeRoute, (_) => false);
                              }
                            } on InvalidEmailAuthException {
                              await showErrorDialog(
                                context,
                                "Invalid email address",
                              );
                            } on UserDiabledAuthException {
                              await showErrorDialog(
                                context,
                                "User is disabled",
                              );
                            } on UserNotFoundAuthException {
                              await showErrorDialog(
                                context,
                                "User is not found",
                              );
                            } on WrongCredentialAuthException {
                              await showErrorDialog(
                                context,
                                "Invalid email or password",
                              );
                            } on GenericAuthException {
                              await showErrorDialog(
                                context,
                                "Login failed, try again later",
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        child: _isLoading
                            ? SizedBox(
                                height: size.hp(2),
                                width: size.wp(5),
                                child: const CircularProgressIndicator(),
                              )
                            : const Text('Login'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton.icon(
                        style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(10.0),
                          animationDuration: Duration(seconds: 2),
                          enableFeedback: true,
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordResetVeiw(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.lock_reset),
                        label: const Text('Forgot Password'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (_) => false);
                        },
                        child: const Text("Haven't register? Register here"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isLoadingG = true;
                          });
                          try {
                            User? user =
                                await _googleSignInService.signInWithGoogle();
                            if (user != null) {
                              // Navigate to home or dashboard page after successful sign-in
                              Navigator.pushNamedAndRemoveUntil(
                                  context, homeRoute, (_) => false);
                            }
                          } on Exception catch (e) {
                            print(e.toString());
                          } finally {
                            setState(() {
                              _isLoadingG = false;
                            });
                          }
                        },
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(5.0),
                          animationDuration: const Duration(seconds: 2),
                          enableFeedback: true,
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              vertical: size.hp(2),
                              horizontal: size.wp(20),
                            ),
                          ),
                        ),
                        icon: !_isLoadingG
                            ? const Icon(FontAwesomeIcons.google)
                            : SizedBox(
                                height: size.hp(2),
                                width: size.wp(5),
                                child: const CircularProgressIndicator(),
                              ),
                        label: const Text("Login with Google"),
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

Future<void> displayDialog(BuildContext context) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: const Text("Login Successful"),
        content: const Text(
            "Your email address has not been verified, proceed to verify your email address"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, emailVerifyRoute, (_) => false),
            child: const Text("Done"),
          )
        ],
      );
    },
  );
}
