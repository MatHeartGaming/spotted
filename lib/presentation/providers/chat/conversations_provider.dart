import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';

final conversationsProvider = StreamProvider.autoDispose
    .family<List<Conversation>, String>((ref, userId) {
      return ref.watch(chatRepositoryProvider).watchUserConversations(userId);
    });

final messagesProvider = StreamProvider.autoDispose
    .family<List<ChatMessageModel>, String>((ref, convoId) {
      return ref.watch(chatRepositoryProvider).watchMessages(convoId);
    });

/// Action provider to send a message
final sendMessageProvider = Provider(
  (ref) =>
      (ChatMessageModel msg) => ref.watch(chatRepositoryProvider).sendMessage(msg),
);

/// Action provider to update typing status
final setTypingProvider = Provider(
  (ref) =>
      (String convoId, List<String> users) =>
          ref.watch(chatRepositoryProvider).setTyping(convoId, users),
);

/// Action provider to mark messages read
final markReadProvider = Provider(
  (ref) =>
      (String convoId, String userId, DateTime timestamp) =>
          ref.watch(chatRepositoryProvider).updateLastRead(convoId, userId, timestamp),
);
