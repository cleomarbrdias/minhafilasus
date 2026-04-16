class AppConfig {
  AppConfig._();

  static const String environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'desenvolvimento',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String govBrClientId = String.fromEnvironment(
    'GOVBR_CLIENT_ID',
    defaultValue: '',
  );

  static const String govBrRedirectUri = String.fromEnvironment(
    'GOVBR_REDIRECT_URI',
    defaultValue: '',
  );

  static const String govBrIssuer = String.fromEnvironment(
    'GOVBR_ISSUER',
    defaultValue: '',
  );

  static bool get isGovBrConfigured =>
      govBrClientId.isNotEmpty &&
      govBrRedirectUri.isNotEmpty &&
      govBrIssuer.isNotEmpty;

  static bool get isSesConfigured => apiBaseUrl.isNotEmpty;
}
