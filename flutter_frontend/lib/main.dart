import 'package:five_jars_ultra/core/config/env_config.dart';
import 'package:five_jars_ultra/core/config/router/router.dart';
import 'package:five_jars_ultra/core/state/app_state_cubit.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the global logger to print in this format
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name} '
      '[${record.loggerName}] '
      '${record.time}: '
      '${record.message}',
    );
  });

  // Initialize Dependency Injections the Holy Grail
  await di.init();

  // Use the get_it initalized config to set the logger level
  final envConfig = di.serviceLocator<EnvConfig>();
  Logger.root.level = envConfig.env == 'prod' ? Level.WARNING : Level.ALL;

  // Ensure portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false, // Run this immediately to check for an existing session
          create: (_) {
            final bloc = di.serviceLocator<AuthSessionBloc>();
            bloc.add(AppStarted());
            return bloc;
          },
        ),
        BlocProvider(
          lazy: false, // Run this immediately to set the app state to loading
          create: (_) {
            final cubit = di.serviceLocator<AppStateCubit>();
            // Set the splash screen until the session bloc is determined
            cubit.runTasks(
              tasks: [di.serviceLocator<AuthSessionBloc>().isReady],
            );

            return cubit;
          },
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = di.serviceLocator<AppRouter>().config;

    return MaterialApp.router(
      title: '5 Jars Ultra',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 90, 28, 109),
        ),
      ),
    );
  }
}
