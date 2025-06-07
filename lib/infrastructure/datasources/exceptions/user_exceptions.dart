// lib/infrastructure/exceptions/user_exceptions.dart

import 'package:easy_localization/easy_localization.dart';

/// Base class for any “user creation” error.
abstract class UserCreationException implements Exception {
  final String message;
  UserCreationException(this.message);

  @override
  String toString() => message;
}

/// Thrown when the email is already in use.
class EmailAlreadyExistsException extends UserCreationException {
  EmailAlreadyExistsException(String email)
      : super("login_signupe_unknown_error_error".tr(args: [email]));
}

/// Thrown when the username is already taken.
class UsernameAlreadyExistsException extends UserCreationException {
  UsernameAlreadyExistsException(String username)
      : super("login_screen_username_already_exists_snackbar".tr(args: [username]));
}

/// Fallback/“generic” error if something else goes wrong.
class GenericUserCreationException extends UserCreationException {
  GenericUserCreationException(super.message);
}
