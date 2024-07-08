import 'package:flutter/material.dart';

showSnackBarMessage(
    BuildContext context, //parameters
    String message,
    [bool isError = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : null,
    ),
  );
}
