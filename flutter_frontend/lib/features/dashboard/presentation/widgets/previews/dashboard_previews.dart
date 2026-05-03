import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jar_card.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jars_grid.dart';
import 'package:five_jars_ultra/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(group: "Dashboard > Jars", name: "Jar Cards + Empty Grid")
Widget previewCardsAndEmptyGrid() {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: JarCard(
                  jar: JarModel(
                    id: "1337",
                    name: "Test Card",
                    balance: Decimal.parse("22090509.99"),
                    coefficient: Decimal.parse("25.0"),
                    createdAt: DateTime.now(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: JarCard(
                  jar: JarModel(
                    id: "1337",
                    name: "Test Card With A Very Long Name",
                    balance: Decimal.parse("2209.00"),
                    coefficient: Decimal.parse("99.99"),
                    createdAt: DateTime.now(),
                  ),
                ),
              ),
              JarsGrid(jars: []),
            ],
          ),
        ),
      ),
    ),
  );
}

@Preview(group: "Dashboard > Jars", name: "Jar Grids")
Widget previewJarGrids() {
  return CustomScrollView(
    slivers: [
      JarsGrid(jars: _sampleJars(2)),
      const SliverToBoxAdapter(child: Divider(height: 20)),
      JarsGrid(jars: _sampleJars(5)),
    ],
  );
}

List<JarModel> _sampleJars(int count) {
  final names = ['Necessities', 'Play', 'Education', 'Savings', 'Investments'];
  final balances = ['1250.00', '430.50', '890.00', '3200.00', '5600.75'];
  return List.generate(
    count,
    (i) => JarModel(
      id: '${1337 + i}',
      name: names[i % names.length],
      balance: Decimal.parse(balances[i % balances.length]),
      coefficient: Decimal.parse('${20 + i * 5}.0'),
      createdAt: DateTime.now(),
    ),
  );
}
