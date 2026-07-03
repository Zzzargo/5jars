import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_state.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jars_distribution_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JarsDistributionView extends StatelessWidget {
  const JarsDistributionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JarsBloc, JarsState>(
      builder: (context, state) {
        if (state is JarsLoadSuccess && state.jars.isNotEmpty) {
          return JarsDistributionChart(jars: state.jars);
        }

        // Return a "Ghost" or "Empty" version of the chart while loading or if empty
        return Container(
          height: 240,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: Text(
              "Waiting for account data...",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
