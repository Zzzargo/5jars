import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_state.dart';
import 'package:five_jars_ultra/features/transactions/models/transaction_type.dart';
import 'package:five_jars_ultra/features/transactions/models/transactions_filters.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
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

    final state = context.watch<TransactionsBloc>().state;

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
            _buildFilterBar(context, state),
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
    final state = context.watch<TransactionsBloc>().state;
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
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFilterBar(context, state),
          ),

          const Divider(height: 16),

          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: TransactionsView(),
                ),
                const TransactionsMoreIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, TransactionsState state) {
    final filters = (state is TransactionsLoadSuccess)
        ? state.filters
        : const TransactionsFilters();

    final jarsState = serviceLocator<JarsBloc>().state;
    final jars = (jarsState is JarsLoadSuccess) ? jarsState.jars : [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // JAR DROPDOWN
          _FilterDropdown<String?>(
            label: "Account",
            value: filters.jarId,
            displayValue: filters.jarId == null
                ? "All Jars"
                : jars.any((j) => j.id == filters.jarId)
                ? jars.firstWhere((j) => j.id == filters.jarId).name
                : "Selected Jar",
            items: [
              const PopupMenuItem(value: null, child: Text("All Jars")),
              ...jars.map(
                (j) => PopupMenuItem(value: j.id, child: Text(j.name)),
              ),
            ],
            onSelected: (id) => context.read<TransactionsBloc>().add(
              TransactionsFilterChanged(filters.copyWith(jarId: id)),
            ),
          ),

          // TYPE DROPDOWN
          _FilterDropdown<TransactionType?>(
            label: "Type",
            value: filters.type,
            displayValue: filters.type?.name.toUpperCase() ?? "All Types",
            items: [
              const PopupMenuItem(value: null, child: Text("All Types")),
              ...TransactionType.values.map(
                (t) =>
                    PopupMenuItem(value: t, child: Text(t.name.toUpperCase())),
              ),
            ],
            onSelected: (type) => context.read<TransactionsBloc>().add(
              TransactionsFilterChanged(filters.copyWith(type: type)),
            ),
          ),

          // SORT TOGGLE (Sleeker Action Button)
          TextButton.icon(
            onPressed: () => context.read<TransactionsBloc>().add(
              TransactionsFilterChanged(
                filters.copyWith(descending: !filters.descending),
              ),
            ),
            icon: Icon(
              filters.descending ? Icons.south_rounded : Icons.north_rounded,
              size: 18,
            ),
            label: Text(filters.descending ? "Newest" : "Oldest"),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final String displayValue;
  final T value;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;

  const _FilterDropdown({
    required this.label,
    required this.displayValue,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (context) => items,
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.expand_more_rounded,
              size: 20,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
