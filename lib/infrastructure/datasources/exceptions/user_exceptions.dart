// lib/infrastructure/exceptions/user_exceptions.dart

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
      : super("A user with email '$email' already exists.");
}

/// Thrown when the username is already taken.
class UsernameAlreadyExistsException extends UserCreationException {
  UsernameAlreadyExistsException(String username)
      : super("The username '$username' is already taken.");
}

/// Fallback/“generic” error if something else goes wrong.
class GenericUserCreationException extends UserCreationException {
  GenericUserCreationException(super.message);
}
