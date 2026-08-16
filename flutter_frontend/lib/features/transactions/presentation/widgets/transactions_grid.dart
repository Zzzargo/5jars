import 'package:five_jars_ultra/features/transactions/models/transaction_model.dart';
import 'package:five_jars_ultra/features/transactions/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class TransactionsGrid extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionsGrid({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('No transactions found.')),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        mainAxisSpacing: 20,
        crossAxisSpacing: 32,
        mainAxisExtent: 120, // Fixed height for each card to prevent overflow
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => TransactionCard(transaction: transactions[index]),
        childCount: transactions.length,
      ),
    );
  }
}
