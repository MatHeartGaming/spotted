import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/errors/login_signup_messages.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthDatasource _authSource;

  FirebaseAuthRepository({required AuthDatasource authSource})
      : _authSource = authSource;

  @override
  Future<(LoginSignupMessages?, UserCredential?)> createAccount(
      String email, String password) async {
    return await _authSource.createAccount(email: email, password: password);
  }

  @override
  Future<(LoginSignupMessages?, UserCredential?)> loginIntoAccount(
      String email, String password) async {
    return await _authSource.loginIntoAccount(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    return await _authSource.logout();
  }

  @override
  bool isUserSignedIn() {
    return _authSource.isUserSignedIn();
  }

  @override
  Future<bool> isUserEmailVerified() async {
    return _authSource.isUserEmailVerified();
  }

  @override
  Future<void> sendPasswordResetLink({String? email}) async {
    return await _authSource.sendPasswordResetLink(email);
  }

  @override
  Future<void> sendEmailVerificationLink() async {
    await _authSource.sendEmailVerificationLink();
  }

  @override
  String get signedInUserEmail => _authSource.signedInUserEmail;

  @override
  Future<bool> reloadAndCheckIsUserSignedIn() async {
    return await _authSource.reloadAndCheckIsUserSignedIn();
  }

  @override
  Future<String> reloadAndGetIsUserSignedInEmail() {
    return _authSource.reloadAndGetIsUserSignedInEmail();
  }

  @override
  Future<void> deleteUser() async {
    _authSource.deleteUser();
  }
  
  @override
  String? get authUid => _authSource.authUid;
}
