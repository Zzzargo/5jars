import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
import 'package:five_jars_ultra/features/transactions/presentation/widgets/transactions_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state is TransactionsLoadFailure) {
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

        if (state is TransactionsLoadSuccess) {
          return TransactionsGrid(transactions: state.transactions);
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
