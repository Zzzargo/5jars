import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController _textController;
  final String labelText;
  final bool isRequired;
  final String? hintText;

  const FormTextField({
    super.key,
    required TextEditingController textController,
    required this.labelText,
    this.isRequired = false,
    this.hintText = '',
  }) : _textController = textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(labelText: labelText, hintText: hintText),
      validator: (v) {
        if (isRequired && (v == null || v.isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }
}
