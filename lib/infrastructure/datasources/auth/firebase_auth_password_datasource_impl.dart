import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/infrastructure/errors/login_signup_messages.dart';

class FirebaseAuthDatasourceImpl implements AuthDatasource {
  final _auth = FirebaseAuth.instance;

  @override
  Future<(LoginSignupMessages?, UserCredential?)> createAccount(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user?.sendEmailVerification();
      return (LoginSignupMessages.success, credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.i('The password provided is too weak.');
        return (LoginSignupMessages.weakPassword, null);
      } else if (e.code == 'email-already-in-use') {
        logger.i('The account already exists for that email.');
        return (LoginSignupMessages.emailAlreadyExists, null);
      }
    } catch (e) {
      logger.i(e);
      throw Exception(e);
    }
    return (null, null);
  }

  @override
  Future<(LoginSignupMessages?, UserCredential?)> loginIntoAccount(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (LoginSignupMessages.success, credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        logger.i('No user found for that email or invalid credentials.');
        return (LoginSignupMessages.invalidCredentials, null);
      }
    }
    return (null, null);
  }

  @override
  Future<void> sendPasswordResetLink(String? email) async {
    String emailToReset = email ?? (_auth.currentUser?.email ?? "");
    if (emailRegExp.hasMatch(emailToReset)) {
      _auth.sendPasswordResetEmail(email: emailToReset);
      return;
    }
  }

  @override
  Future<void> sendEmailVerificationLink() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  @override
  Future<bool> isUserEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  @override
  String get signedInUserEmail => _auth.currentUser?.email ?? "";

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  @override
  String? get authUid => _auth.currentUser?.uid;

  @override
  Future<bool> reloadAndCheckIsUserSignedIn() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser != null;
  }

  @override
  Future<String> reloadAndGetIsUserSignedInEmail() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.email ?? '';
  }

  @override
  Future<void> deleteUser() async {
    _auth.currentUser?.delete().onError(
      (error, stackTrace) {
        logger.e(error.toString());
      },
    );
  }
}
