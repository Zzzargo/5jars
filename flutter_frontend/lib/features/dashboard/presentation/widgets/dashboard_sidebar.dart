import 'package:five_jars_ultra/core/state/theme_cubit.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardSidebar extends StatelessWidget {
  final bool isDrawer;

  const DashboardSidebar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isDrawer ? null : 250, // Drawer handles width on mobile
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildLogo(context),
          const SizedBox(height: 24),
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isActive: true,
            onTap: () => _handleNavigation(context),
          ),
          _SidebarItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Accounts',
            onTap: () => _handleNavigation(context),
          ),
          _SidebarItem(
            icon: Icons.history_rounded,
            label: 'Transactions',
            onTap: () => _handleNavigation(context),
          ),
          _SidebarItem(
            icon: context.watch<ThemeCubit>().state == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            label: context.watch<ThemeCubit>().state == ThemeMode.dark
                ? 'Light Mode'
                : 'Dark Mode',
            onTap: () => {
              context.read<ThemeCubit>().state == ThemeMode.dark
                  ? context.read<ThemeCubit>().setLight()
                  : context.read<ThemeCubit>().setDark(),
            },
          ),

          const Spacer(),

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

  void _handleNavigation(BuildContext context) {
    if (isDrawer) {
      Navigator.pop(context); // Closes the drawer on mobile
    }
    // Handle navigation logic here (e.g., changing a state or route)
  }

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
        Text('Five Jars', style: theme.textTheme.displayMedium),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive
            ? cs.primary.withValues(alpha: 0.2)
            : Colors.transparent,
        leading: Icon(icon, color: isActive ? cs.primary : cs.onSurfaceVariant),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? cs.primary : cs.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
