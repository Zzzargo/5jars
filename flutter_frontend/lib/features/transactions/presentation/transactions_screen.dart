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
      final transactionsBloc = context.read<TransactionsBloc>();
      final state = transactionsBloc.state;
      if (state is TransactionsLoadSuccess && !state.isFetchingMore) {
        transactionsBloc.add(MoreTransactionsRequested());
      }
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
    final filters = (state is TransactionsLoadSuccess)
        ? state.filters
        : const TransactionsFilters();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildFilterBar(context, state),
                _buildSortArea(context, filters),
              ],
            ),

            const Divider(height: 16),

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

    final filters = (state is TransactionsLoadSuccess)
        ? state.filters
        : const TransactionsFilters();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSortArea(context, filters),
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

  Widget _buildSortArea(BuildContext context, TransactionsFilters filters) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
          // Sort toggle
          TextButton.icon(
            onPressed: () => context.read<TransactionsBloc>().add(
              TransactionsFilterChanged(
                filters.copyWith(descending: !filters.descending),
              ),
            ),
            icon: Icon(
              filters.descending ? Icons.south_rounded : Icons.north_rounded,
              size: 20,
            ),
            label: Text(filters.descending ? "Newest first" : "Oldest first"),
            style: TextButton.styleFrom(
              foregroundColor: cs.primary,
              backgroundColor: cs.primary.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              enabledMouseCursor: SystemMouseCursors.click,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
    );
  }

  Widget _buildFilterBar(BuildContext context, TransactionsState state) {
    final filters = (state is TransactionsLoadSuccess)
        ? state.filters
        : const TransactionsFilters();

    final jarsState = serviceLocator<JarsBloc>().state;
    final jars = (jarsState is JarsLoadSuccess) ? jarsState.jars : [];

    const clearFilter =
        Object(); // Sentinel that means "clear this filter". I'm getting tired boss

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Filter by jar
          _FilterDropdown<Object?>(
            label: "Jar",
            value: filters.jarId ?? clearFilter,
            displayValue: filters.jarId == null
                ? "All Jars"
                : jars.any((j) => j.id == filters.jarId)
                ? jars.firstWhere((j) => j.id == filters.jarId).name
                : "Selected Jar",
            items: [
              const PopupMenuItem(value: clearFilter, child: Text("All Jars")),
              ...jars.map(
                (j) => PopupMenuItem(value: j.id, child: Text(j.name)),
              ),
            ],
            onSelected: (value) => context.read<TransactionsBloc>().add(
              TransactionsFilterChanged(
                filters.copyWith(
                  jarId: value == clearFilter ? null : value as String?,
                ),
              ),
            ),
          ),

          // Filter by type
          _FilterDropdown<Object?>(
            label: "Type",
            value: filters.type ?? clearFilter,
            displayValue: filters.type?.displayName ?? "All Types",
            items: [
              const PopupMenuItem(value: clearFilter, child: Text("All Types")),
              ...TransactionType.values.map(
                (t) => PopupMenuItem(value: t, child: Text(t.displayName)),
              ),
            ],
            onSelected: (type) => context.read<TransactionsBloc>().add(
              TransactionsFilterChanged(
                filters.copyWith(
                  type: type == clearFilter ? null : type as TransactionType?,
                ),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final buttonRadius =
        (theme.popupMenuTheme.shape as RoundedRectangleBorder?)?.borderRadius
            .resolve(Directionality.of(context)) ??
        BorderRadius.zero;

    return PopupMenuButton<T>(
      borderRadius: buttonRadius,
      onSelected: onSelected,
      itemBuilder: (context) => items.map((item) {
        if (item is PopupMenuItem<T>) {
          return PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            mouseCursor: SystemMouseCursors
                .click, // Had to do this to explicitly set the cursor
            child: item.child,
          );
        }
        return item;
      }).toList(),
      offset: const Offset(0, 12), // ~Floating effect
      tooltip: "", // Remove tooltip
      position: PopupMenuPosition.under,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: buttonRadius,
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: tt.labelSmall?.copyWith(color: cs.primary),
                  ),
                  Text(displayValue, style: tt.labelMedium),
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
      ),
    );
  }
}
