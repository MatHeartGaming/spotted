class UserAlreadyExistsException implements Exception {
  
  final String message;

  UserAlreadyExistsException([this.message = 'A user with this username already exists.']);

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}