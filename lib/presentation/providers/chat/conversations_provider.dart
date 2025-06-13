import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';

final conversationsProvider = StreamProvider.autoDispose
    .family<List<Conversation>, String>((ref, userId) {
      return ref.read(chatRepositoryProvider).watchUserConversations(userId);
    });

final messagesProvider = StreamProvider.autoDispose
    .family<List<ChatMessage>, String>((ref, convoId) {
      return ref.read(chatRepositoryProvider).watchMessages(convoId);
    });

/// Action provider to send a message
final sendMessageProvider = Provider(
  (ref) =>
      (ChatMessage msg) => ref.read(chatRepositoryProvider).sendMessage(msg),
);

/// Action provider to update typing status
final setTypingProvider = Provider(
  (ref) =>
      (String convoId, List<String> users) =>
          ref.read(chatRepositoryProvider).setTyping(convoId, users),
);

/// Action provider to mark messages read
final markReadProvider = Provider(
  (ref) =>
      (String convoId, String userId, DateTime timestamp) =>
          ref.read(chatRepositoryProvider).markRead(convoId, userId, timestamp),
);
