import 'package:spotted/domain/models/conversation.dart' show ChatMessage, Conversation;

abstract class ChatDatasource {
  /// Streams the list of conversations the user participates in.
  Stream<List<Conversation>> getConversations(String userId);

  /// Creates a new conversation (1-1 or group).
  Future<Conversation?> createConversation(Conversation conversation);

  /// Updates an existing conversation document (e.g. typing, lastRead).
  Future<void> updateConversation(Conversation conversation);

  /// Streams messages for a specific conversation.
  Stream<List<ChatMessage>> getMessages(String conversationId);

  /// Sends a new message (adds to subcollection).
  Future<ChatMessage?> sendMessage(ChatMessage message);

  /// Updates the typing users list for a conversation.
  Future<void> updateTyping(String conversationId, List<String> typingUsers);

  /// Updates the last-read timestamp for a user in a conversation.
  Future<void> updateLastRead(String conversationId, String userId, DateTime timestamp);
}