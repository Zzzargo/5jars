import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/shared/app_theme.dart';
import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
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
    final balance = double.parse(jar.balance.toString());
    final theme = Theme.of(context);
    // For the inkwell splash to respect the card's border radius
    final cardRadius =
        (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius
            .resolve(Directionality.of(context)) ??
        BorderRadius.zero;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: cardRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              // The card provides the color
              tileColor: Palette.transparent,
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.account_balance_wallet_rounded),
              ),
              title: Text(jar.name, style: theme.textTheme.titleMedium),
              subtitle: Text('Contribution: ${jar.coefficient}%'),
              trailing: Text(
                currencyFormat.format(balance),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {}, // TODO: Implement Deposit
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    tooltip: 'Deposit',
                  ),
                  IconButton(
                    onPressed: () {}, // TODO: Implement Withdraw
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    tooltip: 'Withdraw',
                  ),
                  // TODO: Make the popup menu less ugly
                  PopupMenuButton<String>(
                    tooltip: 'More actions',
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (value) {
                      // TODO: Implement the menu actions
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'history',
                        child: Text('History'),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Jar'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(group: 'JarCard')
Widget jarCardPreview() {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: JarCard(
            onTap: () => {},
            jar: JarModel(
              id: '1',
              name: 'Savings Jar',
              balance: Decimal.parse('228.51'),
              coefficient: Decimal.parse('0.2'),
              createdAt: DateTime.now(),
            ),
          ),
        ),
      ),
    ),
  );
}
