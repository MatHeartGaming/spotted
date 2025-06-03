import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotted/infrastructure/errors/login_signup_messages.dart';


abstract class AuthRepository {
  Future<(LoginSignupMessages?, UserCredential?)> createAccount(String email, String password);
  Future<(LoginSignupMessages?, UserCredential?)> loginIntoAccount(String email, String password);
  Future<void> logout();
  bool isUserSignedIn();
  Future<bool> reloadAndCheckIsUserSignedIn();
  Future<String> reloadAndGetIsUserSignedInEmail();
  Future<bool> isUserEmailVerified();
  Future<void> sendPasswordResetLink({String? email});
  Future<void> sendEmailVerificationLink();
  Future<void> deleteUser();
  String get signedInUserEmail;
  String? get authUid;
}
