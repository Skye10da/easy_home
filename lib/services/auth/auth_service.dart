import '/services/auth/firebase_auth_provider.dart';

import 'auth_user.dart';

import '/services/auth/auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> signOut() => provider.signOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) =>
      provider.signIn(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) =>
      provider.signUp(
        email: email,
        password: password,
      );

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> delete() => provider.delete();

  @override
  Future<void> reload() => provider.reload();
}
