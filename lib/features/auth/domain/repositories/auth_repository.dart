import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signInWithGovBr();

  Future<void> signOut();
}
