import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/conversation.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/chat/conversations_provider.dart';
import 'package:spotted/presentation/providers/users/signed_in_user_provider.dart';
import 'package:spotted/presentation/providers/users/user_future_providers.dart';
import 'package:spotted/presentation/widgets/shared/circle_picture.dart';

class ChatsScreen extends ConsumerWidget {
  static const name = 'ChatsScreen';

  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInUser = ref.watch(signedInUserProvider)!;
    final convsAsync = ref.watch(conversationsProvider(signedInUser.id));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('chats_screen_app_bar_title').tr()),
      body: convsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(child: Text('chats_screen_no_chats_yet').tr());
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, idx) {
              final convo = conversations[idx];
              final otherId = convo.participantIds.firstWhere(
                (id) => id != signedInUser.id,
              );

              final userAsync = ref.watch(userFutureByIdProvider(otherId));

              final lastMsg = convo.lastMessage;
              final lastMsgText = lastMsg?.text ?? '';
              return userAsync.maybeWhen(
                data:
                    (otherUser) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        tileColor:
                            (lastMsg?.status != MyMessageStatus.read && lastMsg?.senderId != signedInUser.id)
                                ? colors.primaryContainer
                                : null,
                        title: Text(
                          convo.isAnonymous
                              ? anonymousText
                              : otherUser?.atUsername ?? '',
                        ),
                        leading:
                            convo.isAnonymous
                                ? Icon(anonymousIcon)
                                : CirclePicture(
                                  urlPicture: otherUser?.profileImageUrl ?? '',
                                  width: 50,
                                ),
                        subtitle: Text(lastMsgText),
                        trailing: Text(
                          timeAgo(convo.lastUpdatedAt),
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => pushToChatScreen(context, convo.id),
                      ),
                    ),
                orElse: () => SizedBox.shrink(),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) {
          logger.e('Error loading chats: $e - $st');
          return Center(child: Text('chats_screen_error_loading_chats').tr());
        },
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
