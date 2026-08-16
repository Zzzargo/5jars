import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_view.dart';
import 'package:five_jars_ultra/features/transactions/presentation/widgets/transactions_more_indicator.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAtBottom) {
      context.read<TransactionsBloc>().add(MoreTransactionsRequested());
    }
  }

  bool get _isAtBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger when 90% through the list for smooth UX
    return currentScroll >= (maxScroll * 0.9);
  }

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
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const TransactionsView(),
                  const TransactionsMoreIndicator(),
                ],
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: TransactionsView(),
          ),
          const TransactionsMoreIndicator(),
        ],
      ),
    );
  }
}
