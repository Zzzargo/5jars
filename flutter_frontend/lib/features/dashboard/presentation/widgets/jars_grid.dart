import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_state.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JarsGrid extends StatelessWidget {
  final int crossAxisCount;
  const JarsGrid({super.key, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JarsBloc, JarsState>(
      builder: (context, state) {
        if (state is JarsLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is JarsLoadFailure) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${state.message}')),
          );
        }

        if (state is JarsLoadSuccess) {
          if (state.jars.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(child: Text('No jars found. Add one to start!')),
            );
          }

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => JarCard(jar: state.jars[index]),
              childCount: state.jars.length,
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
