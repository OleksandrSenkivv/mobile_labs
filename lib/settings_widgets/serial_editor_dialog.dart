import 'package:flutter/material.dart';

void showSerialEditorDialog(
    BuildContext context, {
      required void Function(String) onSubmitted,
    }) {
  String serialNumber = '';
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Змінити серійний номер'),
      content: TextField(
        onChanged: (value) => serialNumber = value,
        decoration: const InputDecoration(labelText: 'Новий серійний номер'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onSubmitted(serialNumber);
          },
          child: const Text('Зберегти'),
        ),
      ],
    ),
  );
}
