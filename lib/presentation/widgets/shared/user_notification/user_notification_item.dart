import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart' show UserNotification, User;
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

  const _NotificationRow({
    required this.sender,
    required this.content,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postByIdFuture = ref.watch(loadPostByIdFutureProvider(postId));
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CirclePicture(urlPicture: sender.profileImageUrl, width: 50),
        const SizedBox(width: 8),
        // <-- Let the text take up remaining space
        Flexible(
          child: postByIdFuture.maybeWhen(
            data: (post) {
              return Text(
                content,
                style: textStyle,
                softWrap: true,
              ).tr(args: [sender.atUsername, post?.title ?? '']);
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
