import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:minhafilasaude/app/config/app_config.dart';
import 'package:minhafilasaude/features/auth/data/gov_br_auth_repository.dart';
import 'package:minhafilasaude/features/auth/data/mock_auth_repository.dart';
import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, failure }

class AuthState {
  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      user = null,
      errorMessage = null;

  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;

  bool get isBusy => status == AuthStatus.authenticating;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  static const Object _sentinel = Object();

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    Object? errorMessage = _sentinel,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  if (AppConfig.isGovBrConfigured) {
    return GovBrAuthRepository();
  }

  return MockAuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (Ref ref) {
    return AuthController(ref.watch(authRepositoryProvider));
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState.unauthenticated());

  final AuthRepository _repository;

  Future<void> signInWithGovBr() async {
    state = const AuthState(status: AuthStatus.authenticating);

    try {
      final AppUser user = await _repository.signInWithGovBr();

      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (error) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState.unauthenticated();
  }

  void clearError() {
    if (state.status == AuthStatus.failure) {
      state = const AuthState.unauthenticated();
    }
  }
}
