import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Видалити акаунт'),
      content: const Text('Ви впевнені, що хочете видалити акаунт?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Скасувати'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Так'),
        ),
      ],
    );
  }
}

Future<bool> showConfirmDeleteDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => const ConfirmDeleteDialog(),
  );
  return result == true;
}
