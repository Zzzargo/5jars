import 'package:decimal/decimal.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:intl/intl.dart';

// setState(() => jarBalance += Decimal.parse('50.00'));

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
            backgroundColor: theme.colorScheme.surfaceContainer,
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
            style: theme.textTheme.bodyLarge,
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

// @override
// Widget build(BuildContext context) {
//   final currencyFormat = NumberFormat.simpleCurrency(
//     locale: 'ro_MD',
//     name: 'RON',
//   );

//   final balance = double.parse(jar.balance.toString());
//   final theme = Theme.of(context);
//   final cs = theme.colorScheme;
//   final tt = theme.textTheme;

//   // Let the InkWell ripple respect the card's border radius
//   final cardRadius =
//       (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius
//           .resolve(Directionality.of(context)) ??
//       BorderRadius.zero;

//   return Card(
//     clipBehavior: Clip.antiAlias,
//     child: InkWell(
//       onTap: onTap,
//       borderRadius: cardRadius,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundColor: cs.primary,
//               child: Icon(Icons.account_balance_wallet_rounded),
//             ),

//             const SizedBox(width: 14),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   jar.name,
//                   style: tt.titleMedium,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${jar.coefficient}% of income',
//                   style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),

//             const SizedBox(width: 12),

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
//                     _ActionIconButton(
//                       icon: Icons.add_circle_outline_rounded,
//                       tooltip: 'Deposit',
//                       color: Palette.success,
//                       onPressed: () {}, // TODO: Implement deposit
//                     ),
//                     _ActionIconButton(
//                       icon: Icons.remove_circle_outline_rounded,
//                       tooltip: 'Withdraw',
//                       color: Palette.warning,
//                       onPressed: () {}, // TODO: Implement withdraw
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
// }

// ─────────────────────────────────────────────
//  Small colored icon button for quick actions
// ─────────────────────────────────────────────
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20, color: color),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Actions popup — extracted for clarity
// ─────────────────────────────────────────────
enum _JarAction { history, edit, delete }

class _JarActionsMenu extends StatelessWidget {
  final JarModel jar;

  const _JarActionsMenu({required this.jar});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return PopupMenuButton<_JarAction>(
      tooltip: 'Jar actions',
      icon: Icon(Icons.more_vert_rounded, color: cs.onSurfaceVariant),
      offset: const Offset(0, 8),
      // Use the theme's surface container for a proper elevated feel
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) {
        switch (action) {
          case _JarAction.history:
            // TODO: Navigate to history
            break;
          case _JarAction.edit:
            // TODO: Open edit dialog
            break;
          case _JarAction.delete:
            // TODO: Confirm and delete
            break;
        }
      },
      itemBuilder: (context) => [
        // ── Management actions ─────────────
        _menuItem(
          context,
          value: _JarAction.history,
          icon: Icons.history_rounded,
          label: 'History',
          tt: tt,
          cs: cs,
        ),
        _menuItem(
          context,
          value: _JarAction.edit,
          icon: Icons.edit_outlined,
          label: 'Edit Jar',
          tt: tt,
          cs: cs,
        ),

        // ── Divider ────────────────────────
        const PopupMenuDivider(height: 1),

        // ── Destructive ────────────────────
        _menuItem(
          context,
          value: _JarAction.delete,
          icon: Icons.delete_outline_rounded,
          label: 'Delete',
          color: cs.error,
          tt: tt,
          cs: cs,
        ),
      ],
    );
  }

  PopupMenuItem<_JarAction> _menuItem(
    BuildContext context, {
    required _JarAction value,
    required IconData icon,
    required String label,
    required TextTheme tt,
    required ColorScheme cs,
    Color? color,
  }) {
    final itemColor = color ?? cs.onSurface;

    return PopupMenuItem<_JarAction>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: itemColor),
          const SizedBox(width: 12),
          Text(label, style: tt.bodyMedium?.copyWith(color: itemColor)),
        ],
      ),
    );
  }
}

@Preview(name: 'Jar Card')
Widget jarCardPreview() => const _JarCardPreviewWrapper();

class _JarCardPreviewWrapper extends StatefulWidget {
  const _JarCardPreviewWrapper();

  @override
  State<_JarCardPreviewWrapper> createState() => _JarCardPreviewWrapperState();
}

class _JarCardPreviewWrapperState extends State<_JarCardPreviewWrapper> {
  Decimal jarBalance = Decimal.parse('228.51');

  @override
  Widget build(BuildContext context) {
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
              onTap: () => setState(() => jarBalance += Decimal.parse('50.00')),
              jar: JarModel(
                id: '1',
                name: 'Savings Jar',
                balance: jarBalance,
                coefficient: Decimal.parse('0.2'),
                createdAt: DateTime.now(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
