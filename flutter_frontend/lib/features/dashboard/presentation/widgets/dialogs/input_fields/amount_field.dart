import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountField extends StatelessWidget {
  final TextEditingController _amountController;

  const AmountField({
    super.key,
    required TextEditingController amountController,
  }) : _amountController = amountController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(labelText: 'Amount'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Required';
        final val = double.tryParse(v);
        if (val == null || val <= 0) {
          return 'Enter a valid amount';
        }
        return null;
      },
    );
  }
}
