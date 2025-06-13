import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/presentation/screens/screens.dart';

class ChatHandlerScreen extends ConsumerStatefulWidget {
  final String conversationId;

  static const name = 'ChatHandlerScreen';

  const ChatHandlerScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatHandlerScreenState();
}

class _ChatHandlerScreenState extends ConsumerState<ChatHandlerScreen> {
  @override
  Widget build(BuildContext context) {
    return ChatScreen(conversationId: widget.conversationId,);
  }
}
