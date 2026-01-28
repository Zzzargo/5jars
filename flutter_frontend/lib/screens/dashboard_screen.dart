import 'package:flutter/material.dart';
import 'app_screen.dart';
import '../services/api.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends AppScreen {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends AppScreenState<DashboardScreen> {
  /// Build method for the mobile dashboard screen
  @override
  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Welcome to the Dashboard!')),
    );
  }

  /// Build method for the desktop dashboard screen
  @override
  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Welcome to the Dashboard!')),
    );
  }
}
