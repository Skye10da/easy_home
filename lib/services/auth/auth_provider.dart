import '/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> signIn({
    required String email,
    required String password,
  });
  Future<AuthUser> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<void> reload();
   Future<void> delete();
}
