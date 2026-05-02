import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopDashboardSidebar extends StatelessWidget {
  final bool isDrawer;

  const DesktopDashboardSidebar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    // Wrap in SafeArea to handle mobile notches/home indicators
    return SafeArea(
      child: Container(
        width: isDrawer ? null : 280, // Drawer handles width on mobile
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildLogo(context),
            const SizedBox(height: 40),

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.vignette_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        const SizedBox(width: 12),
        Text(
          'Five Jars',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
            : Colors.transparent,
        leading: Icon(
          icon,
          color: isActive
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
