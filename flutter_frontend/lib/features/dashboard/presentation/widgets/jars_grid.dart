import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jar_card.dart';
import 'package:flutter/material.dart';

class JarsGrid extends StatelessWidget {
  final List<JarModel> jars;

  const JarsGrid({super.key, required this.jars});

  @override
  Widget build(BuildContext context) {
    if (jars.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('No jars found. Add one to start!')),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 120, // Fixed height for each card to prevent overflow
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => JarCard(jar: jars[index]),
        childCount: jars.length,
      ),
    );
  }
}
