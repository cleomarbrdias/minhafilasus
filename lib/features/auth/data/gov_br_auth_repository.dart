import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:minhafilasaude/app/config/app_config.dart';
import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/auth/domain/repositories/auth_repository.dart';

class GovBrAuthRepository implements AuthRepository {
  GovBrAuthRepository({FlutterAppAuth? appAuth})
    : _appAuth = appAuth ?? FlutterAppAuth();

  final FlutterAppAuth _appAuth;

  @override
  Future<AppUser> signInWithGovBr() async {
    if (!AppConfig.isGovBrConfigured) {
      throw Exception(
        'Integração gov.br não configurada. Informe GOVBR_CLIENT_ID, '
        'GOVBR_REDIRECT_URI e GOVBR_ISSUER.',
      );
    }

    final AuthorizationTokenResponse response = await _appAuth
        .authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            AppConfig.govBrClientId,
            AppConfig.govBrRedirectUri,
            issuer: AppConfig.govBrIssuer,
            scopes: const <String>['openid', 'profile', 'email'],
            promptValues: const <String>['login'],
          ),
        );

    if (response.idToken == null) {
      throw Exception('Falha ao obter o token de identidade do gov.br.');
    }

    final Map<String, dynamic> claims = _decodeJwt(response.idToken!);

    final String name = (claims['name'] ?? claims['given_name'] ?? 'Cidadão')
        .toString();

    return AppUser(
      id: (claims['sub'] ?? 'govbr-user').toString(),
      fullName: name,
      cpfMasked: '***.***.***-**',
      accessLevel: 'Conta gov.br',
    );
  }

  @override
  Future<void> signOut() async {
    return;
  }

  Map<String, dynamic> _decodeJwt(String token) {
    final List<String> parts = token.split('.');

    if (parts.length < 2) {
      return <String, dynamic>{};
    }

    final String normalized = base64.normalize(parts[1]);
    final String payload = utf8.decode(base64Url.decode(normalized));

    return jsonDecode(payload) as Map<String, dynamic>;
  }
}
