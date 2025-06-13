// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final loadChatProvider = StateNotifierProvider<LoadChatNotifier, LoadChatState>(
  (ref) {
    final chatRepo = ref.watch(chatRepositoryProvider);
    return LoadChatNotifier(chatRepo);
  },
);

class LoadChatNotifier extends StateNotifier<LoadChatState> {
  final ChatRepository _chatRepository;
  LoadChatNotifier(this._chatRepository)
    : super(
        LoadChatState(
          chatController: CustomChatController(),
          conversation: Conversation.empty(),
        ),
      );

  Future<Conversation> initConversation(String id) async {
    final conversation = await _chatRepository.getConversation(id);
    state = state.copyWith(conversation: conversation);
    return conversation;
  }

  void loadChat(Conversation conv) {}

  Future<void> sendMessage(ChatMessageModel message) async {
    await _chatRepository.sendMessage(message);
  }
}

class LoadChatState {
  final Conversation conversation;
  final ChatController chatController;

  LoadChatState({required this.conversation, required this.chatController});

  @override
  bool operator ==(covariant LoadChatState other) {
    if (identical(this, other)) return true;

    return other.conversation == conversation &&
        other.chatController == chatController;
  }

  @override
  int get hashCode => conversation.hashCode ^ chatController.hashCode;

  LoadChatState copyWith({
    Conversation? conversation,
    ChatController? chatController,
  }) {
    return LoadChatState(
      conversation: conversation ?? this.conversation,
      chatController: chatController ?? this.chatController,
    );
  }
}

class CustomChatController implements ChatController {
  final List<Message> _messages = [];
  final StreamController<ChatOperation> _ops =
      StreamController<ChatOperation>.broadcast();

  @override
  List<Message> get messages => List.unmodifiable(_messages);

  @override
  Stream<ChatOperation> get operationsStream => _ops.stream;

  @override
  Future<void> insertAllMessages(List<Message> messages, {int? index}) async {
    // we treat this just like setMessages
    await setMessages(messages);
  }

  @override
  Future<void> setMessages(List<Message> messages) async {
    _messages
      ..clear()
      ..addAll(messages);
    // tell listeners we’ve reset the entire list:
    _ops.add(ChatOperation.set(messages));
  }

  @override
  Future<void> insertMessage(Message message, {int? index}) async {
    final idx = index ?? _messages.length;
    _messages.insert(idx, message);
    _ops.add(ChatOperation.insert(message, idx));
  }

  @override
  Future<void> removeMessage(Message message) async {
    final idx = _messages.indexWhere((m) => m.id == message.id);
    if (idx >= 0) {
      final oldMessage = _messages[idx];
      _ops.add(ChatOperation.remove(oldMessage, idx));
      _messages.removeAt(idx);
    }
  }

  @override
  Future<void> updateMessage(Message oldMessage, Message newMessage) async {
    final idx = _messages.indexWhere((m) => m.id == oldMessage.id);
    if (idx >= 0) {
      _ops.add(ChatOperation.update(_messages[idx], newMessage, idx));
      _messages[idx] = newMessage;
    }
  }

  @override
  void dispose() {
    _ops.close();
  }
}

enum ChatOperationType {
  setMessages,
  insertMessage,
  removeMessage,
  updateMessage,
}
