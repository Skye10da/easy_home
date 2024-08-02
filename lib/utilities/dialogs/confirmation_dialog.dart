import 'package:flutter/material.dart';
import '/utilities/dialogs/generic_dialog.dart';

Future<bool> confirmationDialog( 
  {required BuildContext context,
  required String title,}
) {
  return showGenericDialog(
    title: title,
    content: "Are you sure you want to $title ?",
    context: context,
    optionBuilder: () => {
      "Yes": true,
      "Cancel": false,
    },
  ).then(
    (value) => value ?? false,
  );
}
