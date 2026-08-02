import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/config/env_config.dart';
import 'package:five_jars_ultra/core/config/notification_service.dart';
import 'package:five_jars_ultra/core/config/router/router.dart';
import 'package:five_jars_ultra/core/config/storage.dart';
import 'package:five_jars_ultra/core/state/app_state_cubit.dart';
import 'package:five_jars_ultra/core/state/theme_cubit.dart';
import 'package:five_jars_ultra/features/auth/data/auth_client.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register/register_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/data/jars_client.dart';
import 'package:five_jars_ultra/features/dashboard/data/users_client.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_bloc.dart';
import 'package:five_jars_ultra/features/transactions/data/transactions_client.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> init() async {
  // Global, environment configuration
  serviceLocator.registerLazySingleton(() => EnvConfig.fromEnv());

  // Secure storage for jwts
  serviceLocator.registerLazySingleton(() => SecureStorage());

  // API client to talk with the backend
  assert(serviceLocator.isRegistered<EnvConfig>());
  assert(serviceLocator.isRegistered<SecureStorage>());
  serviceLocator.registerLazySingleton(
    () => ApiHttpClient(serviceLocator(), serviceLocator()),
  );

  // Auth client uses the API client to make auth-specific requests
  assert(serviceLocator.isRegistered<ApiHttpClient>());
  serviceLocator.registerLazySingleton(
    () => AuthClient(serviceLocator(), serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => UsersClient(serviceLocator()));
  serviceLocator.registerLazySingleton(() => JarsClient(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => TransactionsClient(serviceLocator()),
  );

  // App state manager for global loading/ready status
  serviceLocator.registerLazySingleton(() => AppStateCubit());

  // Business logic components (BLoCs) - basically, state managers
  serviceLocator.registerLazySingleton(() => AuthSessionBloc(serviceLocator()));

  assert(serviceLocator.isRegistered<AuthClient>());
  serviceLocator.registerFactory(() => LoginBloc(serviceLocator()));
  serviceLocator.registerFactory(() => RegisterBloc(serviceLocator()));

  serviceLocator.registerLazySingleton(() => JarsBloc(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => TransactionsBloc(serviceLocator()),
  );

  // Router configuration
  assert(serviceLocator.isRegistered<AuthSessionBloc>());
  assert(serviceLocator.isRegistered<AppStateCubit>());
  serviceLocator.registerLazySingleton(
    () => AppRouter(serviceLocator(), serviceLocator()),
  );

  // Theme state
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => prefs);
  assert(serviceLocator.isRegistered<SharedPreferences>());
  serviceLocator.registerLazySingleton(
    () => ThemeCubit(serviceLocator<SharedPreferences>()),
  );

  // Notification service
  serviceLocator.registerLazySingleton(() => NotificationService());

  Logger(
    'InjectionContainer',
  ).info('Dependency injection container initialized');
}
