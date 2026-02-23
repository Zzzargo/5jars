import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_state.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(desktop: _buildDesktop, mobile: _buildMobile);
  }

  Widget _buildDesktop(BuildContext context) {
    final sessionState = context.watch<AuthSessionBloc>().state;
    String username = "User";

    if (sessionState is AuthSessionAuthenticated) {
      username = sessionState.username;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          children: [
            Text('Welcome, $username!'),
            PlatformElevatedButton(
              onPressed: () =>
                  context.read<AuthSessionBloc>().add(UserLoggedOut()),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          children: [
            Text('Welcome to the Dashboard!'),
            PlatformElevatedButton(
              onPressed: () =>
                  context.read<AuthSessionBloc>().add(UserLoggedOut()),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
