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
    return Card(
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
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final User sender;
  final String content;
  final String postId;
  const _NotificationRow({
    required this.sender,
    required this.content,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final texts = TextTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        CirclePicture(urlPicture: sender.profileImageUrl, width: 50),
        Text(content, style: texts.bodyMedium).tr(args: [postId]),
      ],
    );
  }
}
