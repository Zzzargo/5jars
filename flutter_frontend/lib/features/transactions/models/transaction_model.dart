import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/transactions/models/transaction_type.dart';

class TransactionModel {
  final String id;
  final String jarId;
  final String jarName;
  final Decimal amount;
  final TransactionType type;
  final String? description;
  final String correlationId;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.jarId,
    required this.jarName,
    required this.amount,
    required this.type,
    this.description,
    required this.correlationId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      jarId: json['jar_id'],
      jarName: json['jar_name'],
      amount: Decimal.parse(json['amount'].toString()),
      type: TransactionType.values.firstWhere(
        (e) => e.name.toUpperCase() == json['type'],
      ),
      description: json['description'],
      correlationId: json['correlation_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
