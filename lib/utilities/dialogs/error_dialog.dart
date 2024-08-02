import 'package:flutter/material.dart';
import '/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    title: "An error occured",
    content: text,
    context: context,
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
