import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/helpers/haptic_feedback.dart';
import 'package:spotted/domain/models/user_notification.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/providers/user_notifications/load_user_notifications.dart';
import 'package:spotted/presentation/providers/users/signed_in_user_provider.dart';
import 'package:spotted/presentation/widgets/shared/loading_default_widget.dart';
import 'package:spotted/presentation/widgets/shared/user_notification/user_notification_item.dart';
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
      appBar: AppBar(),
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
                        () => _notificationTapAction(notification.postId),
                  );
                },
              ),
    );
  }

  void _notificationTapAction(String postId) {
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
}
