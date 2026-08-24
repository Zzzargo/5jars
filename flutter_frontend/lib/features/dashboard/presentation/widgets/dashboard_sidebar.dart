import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/router/routes.dart';
import 'package:five_jars_ultra/core/state/theme_cubit.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/sidebar_destinations.dart';
import 'package:five_jars_ultra/features/transactions/models/transactions_filters.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardSidebar extends StatelessWidget {
  final bool isDrawer;

  const DashboardSidebar({super.key, this.isDrawer = false});

  Widget _buildLogo(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.view_in_ar_outlined,
          color: theme.colorScheme.primary,
          size: 36,
        ),
        const SizedBox(width: 12),
        Text(
          'Five Jars',
          style: theme.textTheme.displayMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: 40,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final themeCubit = context.watch<ThemeCubit>();
    final themeState = themeCubit.state;

    // Get the current location
    final String location = GoRouterState.of(context).matchedLocation;

    return Container(
      width: isDrawer ? null : 250, // Drawer handles width on mobile
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(right: BorderSide(color: cs.outlineVariant, width: 1)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildLogo(context),
          const SizedBox(height: 24),
          ...sidebarDestinations.map(
            (dest) => _SidebarItem(
              icon: dest.icon,
              label: dest.label,
              isActive: location.startsWith(dest.path),
              onTap: () {
                if (isDrawer) Navigator.pop(context);

                if (dest.path == AppRoutes.transactions) {
                  // Reset filters when going to the transactions screen from the sidebar (UX)
                  serviceLocator<TransactionsBloc>().add(
                    TransactionsFilterChanged(const TransactionsFilters()),
                  );
                }

                context.go(dest.path);
              },
            ),
          ),

          const Spacer(),

          _SidebarItem(
            icon: themeState == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            label: themeState == ThemeMode.dark ? 'Light Mode' : 'Dark Mode',
            onTap: () => themeCubit.toggle(context),
          ),

          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Logout',
            onTap: () {
              // 1. Close drawer if on mobile
              if (isDrawer) Navigator.pop(context);
              // 2. Dispatch logout event
              context.read<AuthSessionBloc>().add(UserLoggedOut());
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: cs.surfaceContainerLowest,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: isActive
              ? cs.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          leading: Icon(
            icon,
            color: isActive ? cs.primary : cs.onSurfaceVariant,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isActive ? cs.primary : cs.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
