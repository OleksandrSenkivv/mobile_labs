import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Помилка'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showSuccessDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Успіх'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
