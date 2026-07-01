import 'package:decimal/decimal.dart';

class MoneyOpRequest {
  final Decimal amount;
  final String description;

  MoneyOpRequest({required this.amount, required this.description});

  Map<String, dynamic> toJson() {
    return {'amount': amount.toString(), 'description': description};
  }
}
