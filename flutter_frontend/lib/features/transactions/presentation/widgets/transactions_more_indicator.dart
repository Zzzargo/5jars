import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsMoreIndicator extends StatelessWidget {
  const TransactionsMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoadSuccess && state.isFetchingMore) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }

        // When the indicator is not in use show nothing
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
