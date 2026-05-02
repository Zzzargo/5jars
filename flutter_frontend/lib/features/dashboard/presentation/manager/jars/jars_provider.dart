import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_state.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jars_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JarsProvider extends StatelessWidget {
  const JarsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JarsBloc, JarsState>(
      builder: (context, state) {
        if (state is JarsLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state is JarsLoadFailure) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is JarsLoadSuccess) {
          return JarsGrid(jars: state.jars);
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
