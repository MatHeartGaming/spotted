/// Thrown when trying to create a community whose title is already in use.
class CommunityAlreadyExistsException implements Exception {
  /// Optional human-readable message.
  final String message;

  /// Creates the exception, optionally supplying a custom message.
  CommunityAlreadyExistsException([this.message = 'A community with this title already exists.']);

  @override
  String toString() => 'CommunityAlreadyExistsException: $message';
}
