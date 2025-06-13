import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/conversation.dart';
import 'package:spotted/presentation/providers/chat/conversations_provider.dart';
import 'package:spotted/presentation/providers/users/signed_in_user_provider.dart';


class ChatsScreen extends ConsumerWidget {
  static const name = 'ChatsScreen';

  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider)!;
    final convsAsync = ref.watch(conversationsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: convsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(child: Text('No chats yet'));
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, idx) {
              final convo = conversations[idx];
              // Determine display title
              String title;
              if (convo.type == ChatType.direct) {
                final otherId = convo.participantIds
                    .firstWhere((id) => id != user.id);
                // In a real app, you'd map otherId to username via a user provider/cache
                title = otherId;
              } else {
                title = convo.groupName ?? 'Group Chat';
              }
              final lastMsg = convo.lastMessage?.text ?? '';
              return ListTile(
                title: Text(title),
                subtitle: Text(lastMsg),
                trailing: Text(
                  timeAgo(convo.lastUpdatedAt),
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () async {
                  // Navigate to chat screen
                  
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading chats')),
      ),
    );
  }
}


String timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}