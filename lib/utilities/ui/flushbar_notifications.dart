import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showSuccessNotification(BuildContext context, String message) {
  Flushbar(
    title: 'Success',
    message: message,
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 3),
  ).show(context);
}

void showErrorNotification(BuildContext context, String message) {
  Flushbar(
    title: 'Error',
    message: message,
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
  ).show(context);
}
