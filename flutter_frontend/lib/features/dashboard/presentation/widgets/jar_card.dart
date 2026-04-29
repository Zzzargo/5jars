import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JarCard extends StatelessWidget {
  final JarModel jar;
  final VoidCallback? onTap;

  const JarCard({super.key, required this.jar, this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();
    // Convert Decimal to double only for presentation
    final balance = double.parse(jar.balance.toString());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        // Adds "Splash" effect when clicked
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              jar.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Contribution: ${jar.coefficient}%',
              style: TextStyle(color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              currencyFormat.format(balance),
              style: const TextStyle(
                fontFamily: 'monospace', // Alignment integrity
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
