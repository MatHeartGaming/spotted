// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_chat_core/flutter_chat_core.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final loadChatProvider = StateNotifierProvider.autoDispose<LoadChatNotifier, LoadChatState>(
  (ref) {
    final chatRepo = ref.watch(chatRepositoryProvider);
    final userRepo = ref.watch(usersRepositoryProvider);
    return LoadChatNotifier(chatRepo, userRepo, ref);
  },
);

class LoadChatNotifier extends StateNotifier<LoadChatState> {
  final ChatRepository _chatRepository;
  final UsersRepository _userRepo;
  final Ref
  _ref; //! <–– In order to not trigger rebuilds of this Notifier and loose posts!!!
  StreamSubscription<List<ChatMessageModel>>? _messagesSub;

  LoadChatNotifier(this._chatRepository, this._userRepo, this._ref)
    : super(
        LoadChatState(
          chatController: CustomChatController(),
          conversation: Conversation.empty(),
          otherUser: UserModel.empty(),
        ),
      );

  @override
  void dispose() {
    _messagesSub?.cancel();
    state.chatController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  UserModel get _signedInUser {
    // We use `read` instead of `watch` to avoid rebuilding the notifier itself.
    return _ref.read(signedInUserProvider) ?? UserModel.empty();
  }

  Future<UserModel?> loadOtherUser(String userId) async {
    if (state.isLoadingOtherUser) return state.otherUser;
    state = state.copyWith(isLoadingOtherUser: true);
    final otherUser = await _userRepo.getUserById(userId);
    state = state.copyWith(isLoadingOtherUser: false, otherUser: otherUser);
    return otherUser;
  }

  Future<Conversation> initConversation(String id) async {
    final conv = await _chatRepository.getConversation(id);
    state = state.copyWith(conversation: conv);

    // cancel any previous listener
    await _messagesSub?.cancel();

    // subscribe to the Firestore stream
    _messagesSub = _chatRepository
        .watchMessages(conv.id)
        .listen(_onNewMessageBatch);

    return conv;
  }

  /// 2️⃣ Handle each new batch of domain messages
  Future<void> _onNewMessageBatch(List<ChatMessageModel> models) async {
    // map to UI messages
    final uiMessages = models.map(_toUiMessage).toList();

    // 3️⃣ push into your controller
    await state.chatController.setMessages(uiMessages);
  }

  /// maps your model → flutter_chat_ui Message
  Message _toUiMessage(ChatMessageModel m) {
    return TextMessage(
      id: m.id,
      authorId: m.senderId,
      createdAt: m.timestamp,
      text: m.text ?? '',
    );
  }

  Future<void> sendMessage(ChatMessageModel message) async {
    await _chatRepository.sendMessage(message);
  }

  Future markLastMessageAsRead() async {
    if (state.conversation.lastMessage?.senderId == _signedInUser.id) return;
    _chatRepository.updateLastRead(
      state.conversation.id,
      _signedInUser.id,
      markAsRead: true,
      DateTime.now(),
    );
  }
}

class LoadChatState {
  final Conversation conversation;
  final UserModel otherUser;
  final ChatController chatController;
  final bool isLoadingOtherUser;

  LoadChatState({
    required this.conversation,
    required this.chatController,
    required this.otherUser,
    this.isLoadingOtherUser = false,
  });

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
    UserModel? otherUser,
    ChatController? chatController,
    bool? isLoadingOtherUser,
  }) {
    return LoadChatState(
      conversation: conversation ?? this.conversation,
      chatController: chatController ?? this.chatController,
      otherUser: otherUser ?? this.otherUser,
      isLoadingOtherUser: isLoadingOtherUser ?? this.isLoadingOtherUser,
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
