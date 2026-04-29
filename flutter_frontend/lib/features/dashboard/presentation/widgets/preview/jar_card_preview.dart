import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: "Jar Card")
Widget jarCardPreview() {
  return JarCard(
    jar: JarModel(
      id: "1337",
      name: "Test Card",
      balance: Decimal.parse("22090509.99"),
      coefficient: Decimal.parse("25.0"),
      createdAt: DateTime.now(),
    ),
  );
}
