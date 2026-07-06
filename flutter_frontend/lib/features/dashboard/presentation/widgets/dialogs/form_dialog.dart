import 'package:flutter/material.dart';

class FormDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final String confirmText;
  final VoidCallback onConfirm;

  const FormDialog({
    super.key,
    required this.title,
    required this.child,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: child),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: onConfirm, child: Text(confirmText)),
      ],
    );
  }
}
