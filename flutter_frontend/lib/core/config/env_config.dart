class EnvConfig {
  final String apiBaseUrl;
  final String env;

  EnvConfig({required this.apiBaseUrl, required this.env});

  factory EnvConfig.fromEnv() {
    const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const String env = String.fromEnvironment('ENV');
    if (apiBaseUrl.isEmpty || env.isEmpty) {
      throw Exception(
        'API_BASE_URL and ENV must be set in the environment variables',
      );
    }

    return EnvConfig(apiBaseUrl: apiBaseUrl, env: env);
  }
}
