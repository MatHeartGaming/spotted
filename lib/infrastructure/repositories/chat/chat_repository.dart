import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/chat/chat_datasource_firebase_impl.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource _datasource;
  ChatRepositoryImpl([ChatDatasource? datasource])
    : _datasource = datasource ?? ChatDatasourceFirebaseImpl();

  @override
  Stream<List<Conversation>> watchUserConversations(String userId) =>
      _datasource.getConversations(userId);

  @override
  Future<Conversation?> createConversation(Conversation convo) =>
      _datasource.createConversation(convo);

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) =>
      _datasource.getMessages(conversationId);

  @override
  Future<ChatMessage?> sendMessage(ChatMessage message) =>
      _datasource.sendMessage(message);

  @override
  Future<void> setTyping(String conversationId, List<String> users) =>
      _datasource.updateTyping(conversationId, users);

  @override
  Future<void> markRead(
    String conversationId,
    String userId,
    DateTime timestamp,
  ) => _datasource.updateLastRead(conversationId, userId, timestamp);
}
