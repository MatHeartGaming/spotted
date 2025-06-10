import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/errors/login_signup_messages.dart';
import 'package:spotted/presentation/providers/providers.dart';

final authStatusProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  final authPasswordProvider = ref.watch(authPasswordRepositoryProvider);

  return AuthStateNotifier(
    authPasswordRepository: authPasswordProvider,
    //authAppleRepository: authAppleProvider,
  );
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository authPasswordRepository;
  final _logger = Logger();

  AuthStateNotifier({required this.authPasswordRepository})
    : super(AuthState()) {
    checkAuthStatus();
  }

  @override
  void dispose() {
    _logger.i("AuthStateNotifier has been disposed!");
    super.dispose();
  }

  void checkAuthStatus() async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    final isLoggedIn =
        await authPasswordRepository.reloadAndCheckIsUserSignedIn();
    if (!isLoggedIn) {
      state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
      await authPasswordRepository.logout();
      return;
    }
    state = state.copyWith(authStatus: AuthStatus.authenticated);
  }

  Future<UserCredential?> loginUsingPassword(
    String email,
    String password, {
    Function? onInvalidCredentials,
    Function? onTooManyAttempts,
    Function? onUnkownError,
  }) async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    final userCredential = await authPasswordRepository.loginIntoAccount(
      email,
      password,
    );
    final message = userCredential.$1;
    if (message != null && message != LoginSignupMessages.success) {
      switch (message) {
        case LoginSignupMessages.invalidCredentials:
          if (onInvalidCredentials != null) onInvalidCredentials();
          state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
          return null;
        case LoginSignupMessages.unkownError:
          if (onUnkownError != null) onUnkownError();
          state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
          return null;
        case LoginSignupMessages.tooManyAttempts:
          if (onTooManyAttempts != null) onTooManyAttempts();
          state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
          return null;
        default:
          return null;
      }
    }
    if (userCredential.$2 != null) {
      state = state.copyWith(authStatus: AuthStatus.authenticated);
    } else {
      state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
    }
    return userCredential.$2;
  }

  Future<UserCredential?> signupUsingPassword(
    String email,
    String password, {
    Function? onEmailAlreadyExists,
    Future<bool> Function(UserCredential?)? onAuthSuccess,
  }) async {
    //state = state.copyWith(authStatus: AuthStatus.checking);
    final userCredential = await authPasswordRepository.createAccount(
      email,
      password,
    );
    final message = userCredential.$1;
    if (message != null && message != LoginSignupMessages.success) {
      switch (message) {
        case LoginSignupMessages.emailAlreadyExists:
          state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
          if (onEmailAlreadyExists != null) onEmailAlreadyExists();
          return null;
        default:
          return null;
      }
    }
    if (userCredential.$2 != null) {
      bool userCreationResult = false;
      if (onAuthSuccess != null) {
        userCreationResult = await onAuthSuccess(userCredential.$2);
      }
      if (userCreationResult) {
        state = state.copyWith(authStatus: AuthStatus.authenticated);
      } else {
        // The User could not be created on DB too
        authPasswordRepository.deleteUser();
      }
    } else {
      state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
    }
    return userCredential.$2;
  }

  Future<void> logout() async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    await authPasswordRepository.logout().then(
      (value) =>
          state = state.copyWith(authStatus: AuthStatus.notAuthenticated),
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  //final UserCredential? userCredential;
  final String errorMessage;
  static bool? emailVerified;

  AuthState({
    this.authStatus = AuthStatus.checking,
    //this.userCredential,
    this.errorMessage = "",
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    //UserCredential? userCredential,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    //userCredential: userCredential ?? this.userCredential,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
