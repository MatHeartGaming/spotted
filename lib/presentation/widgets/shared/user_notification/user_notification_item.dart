import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart' show UserNotification, User;
import 'package:spotted/domain/models/user_notification.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class UserNotificationItem extends ConsumerWidget {
  final UserNotification notificationItem;
  final VoidCallback onNotificationTapped;

  const UserNotificationItem({
    super.key,
    required this.notificationItem,
    required this.onNotificationTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final senderFuture = ref.watch(
      userFutureByIdProvider(notificationItem.senderId),
    );
    final colors = Theme.of(context).colorScheme;

    // If not clicked, use primaryContainer as card bg; otherwise default.
    final cardColor = notificationItem.clicked
        ? null
        : colors.primaryContainer;

    return InkWell(
      onTap: onNotificationTapped,
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: senderFuture.maybeWhen(
            data: (sender) => sender != null
                ? _NotificationRow(
                    sender: sender,
                    content: notificationItem.content,
                    postId: notificationItem.postId,
                    type: notificationItem.type,
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}


class _NotificationRow extends ConsumerWidget {
  final User sender;
  final String content;
  final String postId;
  final UserNotificationType type;

  const _NotificationRow({
    required this.sender,
    required this.content,
    required this.postId,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;
    // Fast path for “Follow” notifications
    if (type == UserNotificationType.Follow) {
      final msg = content.tr(args: [sender.atUsername]);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CirclePicture(urlPicture: sender.profileImageUrl, width: 50),
          const SizedBox(width: 8),
          Flexible(child: Text(msg, style: textStyle)),
        ],
      );
    }

    // Otherwise treat as Comment (or Unknown)
    final postByIdFuture = ref.watch(loadPostByIdFutureProvider(postId));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CirclePicture(urlPicture: sender.profileImageUrl, width: 50),
        const SizedBox(width: 8),
        Flexible(
          child: postByIdFuture.maybeWhen(
            data: (post) {
              final msg = content.tr(
                args: [sender.atUsername, post?.title ?? ''],
              );
              return Text(msg, style: textStyle, softWrap: true);
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
