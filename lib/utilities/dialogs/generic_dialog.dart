import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required String title,
  required String content,
  required BuildContext context,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showAdaptiveDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop(null);
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
