import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/create_jar_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return AlertDialog(
      title: const Text('Add New Jar'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g. Education',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _coeffController,
                decoration: const InputDecoration(
                  labelText: 'Coefficient (%)',
                  hintText: 'e.g. 10',
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final val = double.tryParse(v);
                  if (val == null || val <= 0 || val > 100)
                    return 'Enter 1-100';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitCreateJarRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Create'),
        ),
      ],
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
