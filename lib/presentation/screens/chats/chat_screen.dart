import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

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
    _initConversation();
  }

  void _initConversation() {
    Future(() {
      final signedInUser = ref.read(signedInUserProvider);
      if (signedInUser == null || signedInUser.isEmpty) return;
      ref
          .read(loadChatProvider.notifier)
          .initConversation(widget.conversationId)
          .then((conv) {
            final otherUserIdIndex = conv.participantIds.indexWhere(
              (element) => element != signedInUser.id,
            );
            if (otherUserIdIndex == -1) return;
            ref
                .read(loadChatProvider.notifier)
                .loadOtherUser(conv.participantIds[otherUserIdIndex]);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final signedInUser = ref.watch(signedInUserProvider);
    final chatState = ref.watch(loadChatProvider);
    final chatCtrl = chatState.chatController;
    final isDark = ref.watch(isDarkModeProvider);

    final otherUser = chatState.otherUser;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => pushToProfileScreen(context, user: otherUser),
          child: Text(otherUser.atUsername),
        ),
        leading: _backButton(chatState, signedInUser!, otherUser),
        leadingWidth: 100,
      ),
      body: Chat(
        chatController: chatCtrl,
        currentUserId: signedInUser.id,
        theme: isDark ? ChatTheme.dark() : ChatTheme.light(),
        resolveUser: (id) async {
          return User(id: id);
        },
        onMessageSend: (text) {
          _sendMessage(text);
        },
        builders: Builders(),
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

  Widget _backButton(
    LoadChatState chatState,
    UserModel signedInUser,
    UserModel otherUser,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(FontAwesomeIcons.chevronLeft),
          ),

          GestureDetector(
            onTap: () => pushToProfileScreen(context, user: otherUser),
            child: CirclePicture(
              urlPicture: otherUser.profileImageUrl,
              minRadius: 20,
              maxRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}
