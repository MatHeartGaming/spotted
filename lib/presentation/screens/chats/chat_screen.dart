import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/conversation.dart';
import 'package:spotted/presentation/providers/providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  static const name = 'ChatScreen';

  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _initConversation() {
    Future(() {
      ref
          .read(loadChatProvider.notifier)
          .initConversation(widget.conversationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final signedInUser = ref.watch(signedInUserProvider);
    final chatState = ref.watch(loadChatProvider);
    final chatCtrl = chatState.chatController;
    final isDark = ref.watch(isDarkModeProvider);

    // Listen to chatCtrl.messages or chatCtrl.operationsStream...

    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Chat(
        currentUserId: signedInUser?.id ?? '',
        theme: isDark ? ChatTheme.dark() : ChatTheme.light(),
        resolveUser: (id) async {
          return User(id: id);
        },
        onMessageSend: (text) {
          _sendMessage(text);
        },
        chatController: chatCtrl,
      ),
    );
  }

  void _sendMessage(String message) {
    final signedInUser = ref.watch(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return;
    final chatNotifier = ref.watch(loadChatProvider.notifier);
    final newMessage = ChatMessageModel(
      id: '',
      conversationId: widget.conversationId,
      senderId: signedInUser.id,
      type: MessageType.text,
      text: message,
    );
    chatNotifier.sendMessage(newMessage);
  }
}
