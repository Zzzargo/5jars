import 'package:decimal/decimal.dart';

class CreateJarRequest {
  String name;
  String description;
  Decimal coefficient;

  CreateJarRequest({
    required this.coefficient,
    required this.description,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'coefficient': coefficient.toString(),
    };
  }
}
