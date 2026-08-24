import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/transactions/models/transaction_model.dart';
import 'package:five_jars_ultra/features/transactions/models/transaction_type.dart';
import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final currencyFormat = NumberFormat.currency(
      symbol: 'RON ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    final cardRadius =
        (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius
            .resolve(Directionality.of(context)) ??
        BorderRadius.zero;

    // TODO: make this color depend on transaction success/failure
    final isPositive = transaction.amount > Decimal.zero;
    final isGood =
        transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.incomeDistribution;

    return Card(
      child: InkWell(
        // TODO: show a dialog with transaction details when tapped
        onTap: () => {},
        borderRadius: cardRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 6),
                child: Icon(
                  Icons.circle,
                  size: 16,
                  color: isPositive ? Palette.success : Palette.error,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: 'Jar name: ${transaction.jarName}',
                      waitDuration: const Duration(milliseconds: 500),
                      verticalOffset: 12,
                      child: Text(
                        transaction.jarName,
                        style: tt.titleMedium?.copyWith(
                          color: cs.primaryContainer,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Tooltip(
                      message:
                          '${dateFormat.format(transaction.createdAt)}  ${timeFormat.format(transaction.createdAt)}',
                      waitDuration: const Duration(milliseconds: 500),
                      verticalOffset: 12,

                      child: Text(
                        '${dateFormat.format(transaction.createdAt)}  ${timeFormat.format(transaction.createdAt)}',
                        style: tt.titleSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${isGood ? '+' : '-'}${currencyFormat.format(double.parse(transaction.amount.toString()))}',
                style: tt.labelMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: isGood ? Palette.success : Palette.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
