import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class JarsDistributionChart extends StatelessWidget {
  final List<JarModel> jars;

  const JarsDistributionChart({super.key, required this.jars});

  List<Color> generateChartColors(BuildContext context, int count) {
    final cs = Theme.of(context).colorScheme;

    // Convert thr theme's primary color to HSV to match the vibe
    final HSVColor baseHsv = HSVColor.fromColor(cs.primary);

    return List.generate(count, (index) {
      // Distribute hues evenly across the color wheel (360 degrees)
      double hue = (baseHsv.hue + (index * (360 / count))) % 360;

      return HSVColor.fromAHSV(
        1.0,
        hue,
        // Keep saturation and value adapted to dark/light mode
        baseHsv.saturation.clamp(
          0.4,
          0.7,
        ), // Keeps it from getting too washed out or neon
        baseHsv.value.clamp(0.6, 0.9), // Keeps contrast highly visible
      ).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> chartColors = generateChartColors(context, jars.length);
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isCompact = constraints.maxWidth < 600;

        return Container(
          height: isCompact ? 420 : 260,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: isCompact
              ? _buildVerticalLayout(context, chartColors, cs)
              : _buildHorizontalLayout(context, chartColors, cs),
        );
      },
    );
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    List<Color> chartColors,
    ColorScheme cs,
  ) {
    return Row(
      children: [
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
        Expanded(flex: 1, child: _buildLegend(context, chartColors, cs)),
      ],
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    List<Color> chartColors,
    ColorScheme cs,
  ) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 45,
              sections: _buildChartSections(chartColors),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildLegend(context, chartColors, cs)),
      ],
    );
  }

  Widget _buildLegend(
    BuildContext context,
    List<Color> chartColors,
    ColorScheme cs,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jars Distribution",
          style: TextStyle(
            color: cs.onSurface,
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
                color: chartColors[index],
                percent: "${jar.coefficient * Decimal.fromInt(100)}%",
              );
            },
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections(List<Color> colors) {
    return jars.asMap().entries.map((entry) {
      final index = entry.key;
      final jar = entry.value;

      return PieChartSectionData(
        color: colors[index],
        value: jar.coefficient.toDouble(),
        title: '${jar.coefficient * Decimal.fromInt(100)}%',
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
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: cs.onSurface, fontSize: 12)),
          const Spacer(),
          Text(
            percent,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
