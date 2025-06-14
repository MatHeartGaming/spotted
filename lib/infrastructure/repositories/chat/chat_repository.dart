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
  Stream<List<ChatMessageModel>> watchMessages(String conversationId) =>
      _datasource.watchMessages(conversationId);

  @override
  Future<ChatMessageModel?> sendMessage(ChatMessageModel message) =>
      _datasource.sendMessage(message);

  @override
  Future<void> setTyping(String conversationId, List<String> users) =>
      _datasource.updateTyping(conversationId, users);

  @override
  Future<void> updateLastRead(
    String conversationId,
    String userId,
    DateTime timestamp, {
    bool markAsRead = false,
  }) => _datasource.updateLastRead(
    conversationId,
    userId,
    timestamp,
    markAsRead: markAsRead,
  );

  @override
  Future<Conversation> getOrCreateDirectChat(
    String userA,
    String userB, {
    bool isAnonymous = false,
  }) {
    return _datasource.getOrCreateDirectChat(
      userA,
      userB,
      isAnonymous: isAnonymous,
    );
  }

  @override
  Future<Conversation> getConversation(String id) {
    return _datasource.getConversation(id);
  }
}
