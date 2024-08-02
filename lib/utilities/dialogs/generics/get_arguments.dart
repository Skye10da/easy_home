import 'package:flutter/material.dart';

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalROute = ModalRoute.of(this);
    if (modalROute != null) {
      final args = modalROute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  } 
}
