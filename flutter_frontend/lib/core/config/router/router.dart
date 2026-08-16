import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/router/go_router_refresher.dart';
import 'package:five_jars_ultra/core/config/router/routes.dart';
import 'package:five_jars_ultra/core/state/app_state.dart';
import 'package:five_jars_ultra/core/state/app_state_cubit.dart';
import 'package:five_jars_ultra/features/auth/presentation/login_screen.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register/register_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_state.dart';
import 'package:five_jars_ultra/features/auth/presentation/register_screen.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/dashboard_screen.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_event.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_state.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:five_jars_ultra/features/settings/presentation/settings_screen.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
import 'package:five_jars_ultra/features/transactions/presentation/transactions_screen.dart';
import 'package:five_jars_ultra/shared/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AppStateCubit _appStateCubit;
  final AuthSessionBloc _sessionBloc;

  AppRouter(this._sessionBloc, this._appStateCubit);

  // Whitelist
  static final _publicRoutes = [
    AppRoutes.splash,
    AppRoutes.login,
    AppRoutes.register,
  ];

  late final GoRouter config = GoRouter(
    initialLocation:
        AppRoutes.splash, // Splash screen for transitions and async awaiting
    // Listen to both the session state and the app state for changes
    refreshListenable: Listenable.merge([
      GoRouterRefresher(_sessionBloc.stream),
      GoRouterRefresher(_appStateCubit.stream),
    ]),
    redirect: (context, state) {
      final sessionState = _sessionBloc.state;
      final bool isAtSplash = state.matchedLocation == AppRoutes.splash;
      final isPublicroute = _publicRoutes.contains(state.matchedLocation);
      final appState = _appStateCubit.state;

      // While waiting show the splash screen
      if (sessionState is AuthSessionNone || appState == AppState.loading) {
        return isAtSplash ? null : AppRoutes.splash;
      }

      // UNAUTHENTICATED GATE
      // Prevent unauthenticated users from accessing private routes
      if (sessionState is AuthSessionUnauthenticated) {
        if (isAtSplash || !isPublicroute) return AppRoutes.login;
      }

      // AUTHENTICATED GATE
      // Redirect authenticated users away from auth screens
      if (sessionState is AuthSessionAuthenticated && isPublicroute) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => serviceLocator<LoginBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (_) => serviceLocator<RegisterBloc>(),
          child: const RegisterScreen(),
        ),
      ),

      // Private routes have the common sidebar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final isDesktop = MediaQuery.of(context).size.width > 896;

          final jarsBloc = serviceLocator<JarsBloc>();
          final transactionsBloc = serviceLocator<TransactionsBloc>();

          // Trigger data fetch for initial states of the private BLoCs
          if (jarsBloc.state is JarsInitial) {
            jarsBloc.add(JarsFetchRequested());
          }

          if (transactionsBloc.state is TransactionsInitial) {
            transactionsBloc.add(TransactionsFetchRequested());
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: serviceLocator<JarsBloc>()),
              BlocProvider.value(value: serviceLocator<TransactionsBloc>()),
            ],
            child: Scaffold(
              // On Mobile use the drawer
              drawer: isDesktop
                  ? null
                  : const Drawer(child: DashboardSidebar(isDrawer: true)),
              body: Row(
                children: [
                  // On Desktop the sidebar is permanent
                  if (isDesktop) const DashboardSidebar(),
                  Expanded(
                    // This is where the screens swap
                    child: navigationShell,
                  ),
                ],
              ),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
