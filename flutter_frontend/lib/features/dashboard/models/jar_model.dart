import 'package:decimal/decimal.dart';

class JarModel {
  final String id;
  final String name;
  final String? description;
  final Decimal balance;
  final Decimal coefficient;
  final DateTime createdAt;

  JarModel({
    required this.id,
    required this.name,
    this.description,
    required this.balance,
    required this.coefficient,
    required this.createdAt,
  });

  factory JarModel.fromJson(Map<String, dynamic> json) {
    return JarModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      balance: Decimal.parse(json['balance'].toString()),
      coefficient: Decimal.parse(json['coefficient'].toString()),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
