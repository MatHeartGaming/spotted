import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/presentation/screens/screens.dart';

class ChatHandlerScreen extends ConsumerStatefulWidget {
  final String user1Id;
  final String user2Id;

  static const name = 'ChatHandlerScreen';

  const ChatHandlerScreen({
    super.key,
    required this.user1Id,
    required this.user2Id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatHandlerScreenState();
}

class _ChatHandlerScreenState extends ConsumerState<ChatHandlerScreen> {
  @override
  Widget build(BuildContext context) {
    return ChatsScreen();
  }
}
