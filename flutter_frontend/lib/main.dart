import 'package:five_jars_ultra/features/auth/presentation/manager/login_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:five_jars_ultra/features/auth/presentation/login_screen.dart';
import 'package:five_jars_ultra/features/auth/presentation/register_screen.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/services.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart' as di;

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  // Ensure portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Dependency Injections the Holy Grail
  await di.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    /// Router configuration. App starts at LoginScreen.
    final GoRouter router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => BlocProvider(
            create: (context) => di.serviceLocator<LoginBloc>(),
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => BlocProvider(
            create: (context) => di.serviceLocator<RegisterBloc>(),
            child: const RegisterScreen(),
          ),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: '5 Jars',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 90, 28, 109),
        ),
      ),
      routerConfig: router,
    );
  }
}
