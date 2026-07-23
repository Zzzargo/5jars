import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:flutter/material.dart';

class GlobalTransactionsScreen extends StatelessWidget {
  const GlobalTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(desktop: _buildDesktop, mobile: _buildMobile);
  }

  Widget _buildDesktop(BuildContext context, bool isDesktop) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Global Transactions',
              style: TextStyle(
                color: cs.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: const Text(
          'Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
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
