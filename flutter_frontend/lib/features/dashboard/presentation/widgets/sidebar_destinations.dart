import 'package:five_jars_ultra/core/config/router/routes.dart';
import 'package:flutter/material.dart';

class SidebarDestination {
  final String label;
  final IconData icon;
  final String path;

  const SidebarDestination({
    required this.label,
    required this.icon,
    required this.path,
  });
}

const List<SidebarDestination> sidebarDestinations = [
  SidebarDestination(
    label: 'Dashboard',
    icon: Icons.dashboard_rounded,
    path: AppRoutes.dashboard,
  ),
  SidebarDestination(
    label: 'Transactions',
    icon: Icons.history_rounded,
    path: AppRoutes.transactions,
  ),
  SidebarDestination(
    label: 'Settings',
    icon: Icons.settings_rounded,
    path: AppRoutes.settings,
  ),
];
