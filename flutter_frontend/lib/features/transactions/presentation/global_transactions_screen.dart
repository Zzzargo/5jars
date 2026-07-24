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
            const Expanded(
              child: Center(
                child: Text("Transaction history will be loaded here"),
              ),
            ),
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
      body: const Center(
        child: Text("Transaction history will be loaded here"),
      ),
    );
  }
}
