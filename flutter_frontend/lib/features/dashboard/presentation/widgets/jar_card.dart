import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JarCard extends StatelessWidget {
  final JarModel jar;
  final VoidCallback? onTap;

  const JarCard({super.key, required this.jar, this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: 'ro_MD',
      name: 'RON',
    );
    // Convert Decimal to double only for presentation
    final balance = double.parse(jar.balance.toString());
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          tileColor: theme.colorScheme.secondaryContainer,
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: theme.colorScheme.onSecondaryContainer,
              size: 20,
            ),
          ),
          title: Text(
            jar.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge,
          ),
          subtitle: Text(
            'Contribution: ${jar.coefficient}%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            currencyFormat.format(balance),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
