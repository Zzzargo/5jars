import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class JarsDistributionChart extends StatelessWidget {
  final List<JarModel> jars;

  const JarsDistributionChart({super.key, required this.jars});

  @override
  Widget build(BuildContext context) {
    // Industrial Tip: Define a set of colors for the jars
    final List<Color> chartColors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.secondary,
      Colors.orangeAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
    ];

    return Container(
      height: 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // THE PIE CHART
          Expanded(
            flex: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 45,
                sections: _buildChartSections(chartColors),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // THE DYNAMIC LEGEND
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jars Distribution",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: jars.length,
                    itemBuilder: (context, index) {
                      final jar = jars[index];
                      return _LegendItem(
                        label: jar.name,
                        color: chartColors[index % chartColors.length],
                        percent: "${jar.coefficient}%",
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(List<Color> colors) {
    return jars.asMap().entries.map((entry) {
      final index = entry.key;
      final jar = entry.value;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: jar.coefficient.toDouble(),
        title: '${jar.coefficient}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final String percent;

  const _LegendItem({
    required this.label,
    required this.color,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Text(
            percent,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
