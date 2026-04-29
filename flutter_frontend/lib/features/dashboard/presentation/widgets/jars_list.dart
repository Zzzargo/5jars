import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_state.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JarsList extends StatelessWidget {
  const JarsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JarsBloc, JarsState>(
      builder: (context, state) {
        if (state is JarsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is JarsLoadFailure) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is JarsLoadSuccess) {
          if (state.jars.isEmpty) {
            return const Center(
              child: Text('No jars found. Add one to start!'),
            );
          }

          return Center(
            // Centers the list on Desktop
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ), // Industrial boundary
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.jars.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return JarCard(
                    jar: state.jars[index],
                    onTap: () {
                      // TODO: Navigate to jar details
                    },
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
