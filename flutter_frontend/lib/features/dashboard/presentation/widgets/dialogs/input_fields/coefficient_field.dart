import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoefficientField extends StatelessWidget {
  final TextEditingController _coefficientController;

  const CoefficientField({
    super.key,
    required TextEditingController coefficientController,
  }) : _coefficientController = coefficientController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _coefficientController,
      decoration: const InputDecoration(
        labelText: 'Coefficient (%)',
        hintText: 'e.g. 10',
        suffixText: '%',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Required';
        final val = double.tryParse(v);
        if (val == null || val <= 0 || val > 100) {
          return 'Enter a value in the range 1-100';
        }
        return null;
      },
    );
  }
}
