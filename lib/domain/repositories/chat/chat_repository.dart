import 'package:spotted/domain/models/models.dart';

abstract class ChatRepository {
  Stream<List<Conversation>> watchUserConversations(String userId);

  Future<Conversation?> createConversation(Conversation convo);

  Stream<List<ChatMessageModel>> watchMessages(String conversationId);

  Future<ChatMessageModel?> sendMessage(ChatMessageModel message);

  Future<void> setTyping(String conversationId, List<String> users);

  Future<void> markRead(
    String conversationId,
    String userId,
    DateTime timestamp,
  );
  Future<Conversation> getOrCreateDirectChat(String userA, String userB);
  Future<Conversation> getConversation(String id);
}
