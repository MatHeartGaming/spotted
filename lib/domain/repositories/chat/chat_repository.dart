import 'package:spotted/domain/models/models.dart';

abstract class ChatRepository {
  Stream<List<Conversation>> watchUserConversations(String userId);

  Future<Conversation?> createConversation(Conversation convo);

  Stream<List<ChatMessage>> watchMessages(String conversationId);

  Future<ChatMessage?> sendMessage(ChatMessage message);

  Future<void> setTyping(String conversationId, List<String> users);

  Future<void> markRead(
    String conversationId,
    String userId,
    DateTime timestamp,
  );
}
