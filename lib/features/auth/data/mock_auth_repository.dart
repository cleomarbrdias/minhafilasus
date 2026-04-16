import 'dart:async';

import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<AppUser> signInWithGovBr() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    return const AppUser(
      id: 'govbr-mock-001',
      fullName: 'Maria Silva',
      cpfMasked: '***.456.789-**',
      accessLevel: 'Conta gov.br homologada',
    );
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
