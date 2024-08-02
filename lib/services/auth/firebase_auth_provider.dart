import 'package:easy_home/services/cloud/fcm_token_service.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import '/services/auth/auth_exception.dart';

import 'dart:developer' as devtools show log;
import '/services/auth/auth_provider.dart';
import '/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  final FCMService _fcmService = FCMService();

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> signIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        await _fcmService.storeFCMToken();
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else if (e.code == "user-disabled") {
        throw UserDiabledAuthException();
      } else if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (e.code == "invalid-credential") {
        throw WrongCredentialAuthException();
      } else {
        devtools.log(e.toString());
        throw GenericAuthException();
      }
    } catch (e) {
      devtools.log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> reload() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.reload();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> delete() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.delete();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }
}
