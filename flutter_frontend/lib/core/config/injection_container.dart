import 'package:five_jars_ultra/features/auth/data/auth_client.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:five_jars_ultra/core/config/env_config.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Global, environment configuration
  serviceLocator.registerLazySingleton(() => EnvConfig.fromEnv());
  // API client to talk with the backend
  serviceLocator.registerLazySingleton(() => ApiHttpClient(serviceLocator()));
  // Auth client uses the API client to make auth-specific requests
  serviceLocator.registerLazySingleton(() => AuthClient(serviceLocator()));

  serviceLocator.registerFactory(() => LoginBloc(serviceLocator()));
}
