import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/money_op_request.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/form_dialog.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/input_fields/amount_field.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/input_fields/form_text_field.dart';
import 'package:flutter/material.dart';

class DepositDialog extends StatefulWidget {
  const DepositDialog({super.key});

  @override
  State<DepositDialog> createState() => _DepositDialogState();
}

class _DepositDialogState extends State<DepositDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: "Deposit",
      confirmText: "Deposit",
      onConfirm: _submitJarDepositRequest,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AmountField(amountController: _amountController),
            const SizedBox(height: 16),
            FormTextField(
              textController: _detailsController,
              labelText: "Details (Optional)",
            ),
          ],
        ),
      ),
    );
  }

  void _submitJarDepositRequest() {
    if (_formKey.currentState!.validate()) {
      // Return the request directly from the dialog
      final request = MoneyOpRequest(
        amount: Decimal.parse(_amountController.text),
        description: _detailsController.text.trim(),
      );
      Navigator.pop(context, request);
    }
  }
}
