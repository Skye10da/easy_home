import 'package:flutter/material.dart';
import '/constant/routes.dart';
import '/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

Future<void> emailVerifyDialog(BuildContext context, bool loading, String message) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog.adaptive(
            title: const Text("Account Confirmation"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await AuthService.firebase().reload();
                  devtools.log(AuthService.firebase()
                      .currentUser!
                      .isEmailVerified
                      .toString());
                  if (AuthService.firebase().currentUser!.isEmailVerified) {
                    setState(() {
                      message = 'Account Verified\n✅';
                      loading = false;
                    });
                    Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, homeRoute, (_) => false);
                      },
                    );
                  } else {
                    setState(() {
                      message = 'Account Not Verified\n❌';
                      loading = false;
                    });
                  }
                },
                child: loading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              )
            ],
          );
        },
      );
    },
  );
}