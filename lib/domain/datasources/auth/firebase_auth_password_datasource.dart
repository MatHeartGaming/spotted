import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotted/infrastructure/errors/login_signup_messages.dart';

abstract class AuthDatasource {
  Future<(LoginSignupMessages?, UserCredential?)> createAccount(
      {required String email, required String password});
  Future<(LoginSignupMessages?, UserCredential?)> loginIntoAccount(
      {required String email, required String password});
  Future<void> logout();
  bool isUserSignedIn();
  Future<bool> reloadAndCheckIsUserSignedIn();
  Future<String> reloadAndGetIsUserSignedInEmail();
  Future<bool> isUserEmailVerified();
  Future<void> sendPasswordResetLink(String? email);
  Future<void> sendEmailVerificationLink();
  Future<void> deleteUser();
  String get signedInUserEmail;
  String? get authUid;
}
