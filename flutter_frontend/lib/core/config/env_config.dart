class EnvConfig {
  final String apiBaseUrl;
  final String env;

  EnvConfig({required this.apiBaseUrl, required this.env});

  factory EnvConfig.fromEnv() {
    return EnvConfig(
      apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
      env: const String.fromEnvironment('ENV'),
    );
  }
}
