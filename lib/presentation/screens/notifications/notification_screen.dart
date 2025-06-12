// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/user_notification.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/providers/user_notifications/load_user_notifications.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  static const name = 'NotificationScreen';
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    Future(() {
      final signedInUser = ref.read(signedInUserProvider);
      if (signedInUser == null || signedInUser.isEmpty) return;
      ref
          .read(loadUserNotificationsProvider.notifier)
          .getUserNotifications(signedInUser.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(loadUserNotificationsProvider);
    if (notificationState.isLoadingUserNotifications) {
      return LoadingDefaultWidget();
    }
    return Scaffold(
      appBar: AppBar(title: Text('app_bar_notifications_btn_tooltip').tr()),
      body:
          notificationState.userNotifications.isEmpty
              ? Center(
                child:
                    Text(
                      'user_notifications_screen_no_notifications_texts',
                    ).tr(),
              )
              : ListView.builder(
                itemCount: notificationState.userNotifications.length,
                itemExtent: 100,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final notification =
                      notificationState.userNotifications[index];
                  return UserNotificationItem(
                    notificationItem: notification,
                    onNotificationTapped:
                        () => _notificationTapAction(
                          type: notification.type,
                          postId: notification.postId,
                          userId: notification.senderId,
                        ),
                  );
                },
              ),
    );
  }

  void _notificationTapAction({
    required UserNotificationType type,
    required String postId,
    required String userId,
  }) {
    switch (type) {
      case UserNotificationType.Comment:
        _notificationTypeCommentAction(postId);
        break;
      case UserNotificationType.Follow:
        _notificationTypeFollowAction(userId);
        break;
      case UserNotificationType.Unknown:
        break;
    }
  }

  void _notificationTypeCommentAction(String postId) {
    final postRepo = ref.read(postsRepositoryProvider);

    postRepo.getPostById(postId).then((postInvolved) {
      if (postInvolved == null) {
        hardVibration();
        showCustomSnackbar(
          context,
          'profile_screen_error_follow_btn_text'.tr(),
          backgroundColor: colorNotOkButton,
        );
        return;
      }
      if (!context.mounted) return;
      pushToPostListScreen(
        context,
        postList: [postInvolved],
        searched: postInvolved.title,
      );
    });
  }

  void _notificationTypeFollowAction(String userId) {
    final userRepo = ref.read(usersRepositoryProvider);

    userRepo.getUserById(userId).then((postInvolved) {
      if (postInvolved == null) {
        hardVibration();
        showCustomSnackbar(
          context,
          'profile_screen_error_follow_btn_text'.tr(),
          backgroundColor: colorNotOkButton,
        );
        return;
      }
      if (!context.mounted) return;
      pushToProfileScreen(context, userId: userId);
    });
  }
}
