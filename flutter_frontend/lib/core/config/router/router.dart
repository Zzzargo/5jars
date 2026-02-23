import 'package:five_jars_ultra/core/config/router/go_router_refresher.dart';
import 'package:five_jars_ultra/features/auth/presentation/login_screen.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register/register_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/register_screen.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_state.dart';

class AppRouter {
  final AuthSessionBloc _sessionBloc;

  AppRouter(this._sessionBloc);

  // Whitelist
  static final _publicRoutes = ['/', '/login', '/register'];

  late final GoRouter config = GoRouter(
    initialLocation: '/', // Splash screen for transitions and async awaiting
    refreshListenable: GoRouterRefresher(_sessionBloc.stream),
    redirect: (context, state) {
      final sessionState = _sessionBloc.state;
      final bool isAtSplash = state.matchedLocation == '/';
      final isPublicroute = _publicRoutes.contains(state.matchedLocation);

      // While waiting for the session state show the splash screen
      if (sessionState is AuthSessionNone) {
        return isAtSplash ? null : '/';
      }

      if (sessionState is AuthSessionUnauthenticated && isAtSplash) {
        return '/login';
      }

      // Prevent unauthenticated users from accessing private routes
      if (sessionState is AuthSessionUnauthenticated) {
        return isPublicroute ? null : '/login';
      }

      // Redirect authenticated users away from auth screens
      if (sessionState is AuthSessionAuthenticated && isPublicroute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            // TODO: Design a splash screen
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (_) => serviceLocator<LoginBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => BlocProvider(
          create: (_) => serviceLocator<RegisterBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
