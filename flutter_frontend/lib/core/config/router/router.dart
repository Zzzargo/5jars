import 'package:five_jars_ultra/core/config/router/go_router_refresher.dart';
import 'package:five_jars_ultra/core/config/router/routes.dart';
import 'package:five_jars_ultra/core/state/app_state.dart';
import 'package:five_jars_ultra/core/state/app_state_cubit.dart';
import 'package:five_jars_ultra/features/auth/presentation/login_screen.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register/register_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/register_screen.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/dashboard_screen.dart';
import 'package:five_jars_ultra/shared/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_state.dart';

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
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: BlocProvider(
            create: (_) => serviceLocator<LoginBloc>(),
            child: const LoginScreen(),
          ),
          // TODO: Make transitions consistent across all screens
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (_) => serviceLocator<RegisterBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
