import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jar_card.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jars_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(group: "Dashboard > Jars", name: "Jar Card 1")
Widget previewJarCard1() {
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

@Preview(group: "Dashboard > Jars", name: "Jar Card Long Name")
Widget previewJarCard2() {
  return JarCard(
    jar: JarModel(
      id: "1337",
      name: "Test Card With A Very Long Name",
      balance: Decimal.parse("2209.00"),
      coefficient: Decimal.parse("99.99"),
      createdAt: DateTime.now(),
    ),
  );
}

@Preview(group: "Dashboard > Jars", name: "Jar Grid 1")
Widget previewJarGrid1() {
  return CustomScrollView(
    slivers: [
      JarsGrid(
        jars: [
          JarModel(
            id: "1337",
            name: "Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
          JarModel(
            id: "1338",
            name: "Another Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
        ],
      ),
    ],
  );
}

@Preview(group: "Dashboard > Jars", name: "Jar Grid Empty")
Widget previewJarGridEmpty() {
  return CustomScrollView(slivers: [JarsGrid(jars: [])]);
}

@Preview(group: "Dashboard > Jars", name: "Jar Grid 2")
Widget previewJarGrid2() {
  return CustomScrollView(
    slivers: [
      JarsGrid(
        jars: [
          JarModel(
            id: "1337",
            name: "Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
          JarModel(
            id: "1338",
            name: "Another Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
          JarModel(
            id: "1337",
            name: "Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
          JarModel(
            id: "1337",
            name: "Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
          JarModel(
            id: "1337",
            name: "Test Card",
            balance: Decimal.fromInt(22),
            coefficient: Decimal.fromInt(22),
            createdAt: DateTime.now(),
          ),
        ],
      ),
    ],
  );
}
