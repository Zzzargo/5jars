import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/money_op_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DistributeIncomeDialog extends StatefulWidget {
  const DistributeIncomeDialog({super.key});

  @override
  State<DistributeIncomeDialog> createState() => _DistributeIncomeDialogState();
}

class _DistributeIncomeDialogState extends State<DistributeIncomeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: 'ro_MD',
      name: 'RON',
    );

    return AlertDialog(
      title: const Text('Distribute Income'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the total amount. It will be split across your jars based on their coefficients.',
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Total Amount',
                prefixText: '${currencyFormat.currencyName} ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Distribute')),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        MoneyOpRequest(
          amount: Decimal.parse(_amountController.text),
          description: _descController.text,
        ),
      );
    }
  }
}
