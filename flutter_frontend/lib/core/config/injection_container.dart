import 'package:five_jars_ultra/core/config/router/router.dart';
import 'package:five_jars_ultra/core/config/storage.dart';
import 'package:five_jars_ultra/features/auth/data/auth_client.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register/register_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:five_jars_ultra/core/config/env_config.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:logging/logging.dart';

final serviceLocator = GetIt.instance;

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

  // Business logic components (BLoCs) - basically, state managers
  serviceLocator.registerLazySingleton(() => AuthSessionBloc(serviceLocator()));

  assert(serviceLocator.isRegistered<AuthClient>());
  serviceLocator.registerFactory(() => LoginBloc(serviceLocator()));

  serviceLocator.registerFactory(() => RegisterBloc(serviceLocator()));

  // Router configuration
  assert(serviceLocator.isRegistered<AuthSessionBloc>());
  serviceLocator.registerLazySingleton(() => AppRouter(serviceLocator()));

  Logger(
    'InjectionContainer',
  ).info('Dependency injection container initialized');
}
