import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart' show UserNotification, User;
import 'package:spotted/domain/models/user_notification.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class UserNotificationItem extends ConsumerWidget {
  final UserNotification notificationItem;
  final Function onNotificationTapped;

  const UserNotificationItem({
    super.key,
    required this.notificationItem,
    required this.onNotificationTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiverIdFuture = ref.watch(
      userFutureByIdProvider(notificationItem.senderId),
    );
    return InkWell(
      onTap: () => onNotificationTapped(),
      child: Card(
        child: receiverIdFuture.maybeWhen(
          data:
              (user) =>
                  user != null
                      ? _NotificationRow(
                        sender: user,
                        content: notificationItem.content,
                        postId: notificationItem.postId,
                        type: notificationItem.type,
                      )
                      : SizedBox.shrink(),
          orElse: () => SizedBox.shrink(),
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
