import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/transactions/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  // @override
  // Widget build(BuildContext context) {
  //   final balance = double.parse(jar.balance.toString());
  //   final coef = jar.coefficient * Decimal.fromInt(100);

  //   final currencyFormat = NumberFormat.simpleCurrency(
  //     locale: 'ro_MD',
  //     name: 'RON',
  //   );

  //   final theme = Theme.of(context);
  //   final cs = theme.colorScheme;
  //   final tt = theme.textTheme;

  //   // Let the InkWell ripple respect the card's border radius
  //   final cardRadius =
  //       (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius
  //           .resolve(Directionality.of(context)) ??
  //       BorderRadius.zero;

  //   return Card(
  //     // clipBehavior: Clip.antiAlias,
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: cardRadius,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 children: [
  //                   CircleAvatar(
  //                     backgroundColor: cs.primary,
  //                     child: Icon(Icons.account_balance_wallet_rounded),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Tooltip(
  //                           // Hovering over the jar name shows the full name in case it's truncated
  //                           message: jar.name,
  //                           waitDuration: const Duration(milliseconds: 500),
  //                           // preferBelow: false,
  //                           verticalOffset: 12,
  //                           child: Text(
  //                             jar.name,
  //                             style: tt.titleMedium,
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 2),
  //                         Text(
  //                           '$coef% of income',
  //                           style: tt.labelSmall?.copyWith(
  //                             color: cs.onSurfaceVariant,
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 // Balance
  //                 Text(
  //                   currencyFormat.format(balance),
  //                   style: tt.labelLarge?.copyWith(color: cs.primary),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     _CardActionIconButton(
  //                       icon: Icons.add_circle_outline_rounded,
  //                       tooltip: 'Deposit',
  //                       onPressed: () => _onDeposit(context),
  //                     ),
  //                     _CardActionIconButton(
  //                       icon: Icons.remove_circle_outline_rounded,
  //                       tooltip: 'Withdraw',
  //                       onPressed: () => _onWithdraw(context),
  //                     ),
  //                     _JarActionsMenu(jar: jar),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPositive = transaction.amount > Decimal.zero;

    // Formatting Logic
    final currencyFormat = NumberFormat.currency(
      symbol: 'RON ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Status Indicator Dot
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              Icons.circle,
              size: 12,
              color: isPositive ? Colors.green : cs.error,
            ),
          ),
          const SizedBox(width: 16),

          // 2. Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? 'No description',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction.jarName,
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Text(' · ', style: TextStyle(color: cs.onSurfaceVariant)),
                    Text(
                      '${dateFormat.format(transaction.createdAt)}  ${timeFormat.format(transaction.createdAt)}',
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Amount
          Text(
            '${isPositive ? '+' : ''}${currencyFormat.format(double.parse(transaction.amount.toString()))}',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              fontFamily: 'monospace', // Keeps numbers aligned in lists
              color: isPositive ? Colors.green : cs.error,
            ),
          ),
        ],
      ),
    );
  }
}
