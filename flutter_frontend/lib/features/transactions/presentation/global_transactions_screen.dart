import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_view.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:flutter/material.dart';

class GlobalTransactionsScreen extends StatelessWidget {
  const GlobalTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(desktop: _buildDesktop, mobile: _buildMobile);
  }

  Widget _buildDesktop(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transactions',
              style: tt.displayMedium?.copyWith(color: cs.onSecondaryContainer),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterChip(label: Text("Jar"), onSelected: (value) {}),
                const SizedBox(width: 8),
                FilterChip(label: Text("Type"), onSelected: (value) {}),
                const SizedBox(width: 8),
                FilterChip(label: Text("Date"), onSelected: (value) {}),
              ],
            ),
            Expanded(child: CustomScrollView(slivers: [TransactionsView()])),
          ],
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          'Transactions',
          style: tt.displayMedium?.copyWith(color: cs.onSecondaryContainer),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: TransactionsView(),
          ),
        ],
      ),
    );
  }
}
