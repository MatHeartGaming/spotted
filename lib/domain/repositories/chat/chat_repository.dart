import 'package:spotted/domain/models/models.dart';

abstract class ChatRepository {
  Stream<List<Conversation>> watchUserConversations(String userId);

  Future<Conversation?> createConversation(Conversation convo);

  Stream<List<ChatMessageModel>> watchMessages(String conversationId);

  Future<ChatMessageModel?> sendMessage(ChatMessageModel message);

  Future<void> setTyping(String conversationId, List<String> users);

  Future<void> updateLastRead(
    String conversationId,
    String userId,
    DateTime timestamp, {
    bool markAsRead = false,
  });
  Future<Conversation> getOrCreateDirectChat(
    String userA,
    String userB, {
    bool isAnonymous = false,
  });
  Future<Conversation> getConversation(String id);
}
