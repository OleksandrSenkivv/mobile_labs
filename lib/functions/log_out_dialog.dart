import 'package:flutter/material.dart';

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Підтвердження виходу'),
      content: const Text('Ви дійсно хочете вийти з акаунту?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Вийти'),
        ),
      ],
    ),
  );
}
