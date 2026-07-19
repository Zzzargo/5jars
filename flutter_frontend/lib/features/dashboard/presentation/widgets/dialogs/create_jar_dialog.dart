import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/create_jar_request.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/form_dialog.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/input_fields/coefficient_field.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/input_fields/form_text_field.dart';
import 'package:flutter/material.dart';

class CreateJarDialog extends StatefulWidget {
  const CreateJarDialog({super.key});

  @override
  State<CreateJarDialog> createState() => _CreateJarDialogState();
}

class _CreateJarDialogState extends State<CreateJarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _coeffController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _coeffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: "New Jar",
      confirmText: "Create",
      onConfirm: _submitCreateJarRequest,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormTextField(
              textController: _nameController,
              labelText: "Name",
              isRequired: true,
            ),
            const SizedBox(height: 16),
            FormTextField(
              textController: _descController,
              labelText: "Description (Optional)",
            ),
            const SizedBox(height: 16),
            CoefficientField(coefficientController: _coeffController),
          ],
        ),
      ),
    );
  }

  void _submitCreateJarRequest() {
    if (_formKey.currentState!.validate()) {
      // Return the request directly from the dialog
      final request = CreateJarRequest(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        coefficient:
            Decimal.parse(_coeffController.text) * Decimal.parse('0.01'),
      );
      Navigator.pop(context, request);
    }
  }
}
