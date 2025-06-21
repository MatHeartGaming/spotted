// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/user_notification.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
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
    _initNotifications(refresh: true);
  }

  Future<void> _initNotifications({bool refresh = false}) async {
    Future(() {
      final signedInUser = ref.read(signedInUserProvider);
      if (signedInUser == null || signedInUser.isEmpty) return;
      ref
          .read(loadUserNotificationsProvider.notifier)
          .getUserNotifications(signedInUser.id, refresh);
      _getUnreadNotifications(signedInUser.id);
    });
  }

  void _getUnreadNotifications(String id) {
    final notificationsRepo = ref.read(userNotificationRepositoryProvider);
    notificationsRepo.getUnreadCountByReceiverId(id).then((unread) {
      ref
          .read(userNotificationUnreadProvider.notifier)
          .update((state) => unread);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(loadUserNotificationsProvider);
    if (notificationState.isLoadingUserNotifications) {
      return LoadingDefaultWidget();
    }
    final texts = TextTheme.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('app_bar_notifications_btn_tooltip').tr(),
        actions: [
          TextButton(
            onPressed:
                notificationState.userNotifications.isEmpty
                    ? null
                    : _markAllAsRead,
            child:
                Text(
                  'Segna tutte come lette',
                  style: texts.bodySmall?.copyWith(color: colors.primary),
                ).tr(),
          ),
        ],
      ),

      body:
          notificationState.userNotifications.isEmpty
              ? Center(
                child:
                    Text(
                      'user_notifications_screen_no_notifications_texts',
                    ).tr(),
              )
              : RefreshIndicator(
                onRefresh: () => _initNotifications(),
                child: ListView.builder(
                  itemCount: notificationState.userNotifications.length,
                  itemExtent: 100,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    final notification =
                        notificationState.userNotifications[index];
                    return UserNotificationItem(
                      notificationItem: notification,
                      onNotificationTapped:
                          () => _handleTap(context, ref, notification),
                    );
                  },
                ),
              ),
    );
  }

  void _showLoadingSnackbar() {
    showCustomSnackbar(
      context,
      'user_notifications_screen_loading_snackbar_text'.tr(),
    );
  }

  Future<void> _handleTap(
    BuildContext context,
    WidgetRef ref,
    UserNotification n,
  ) async {
    _showLoadingSnackbar();
    smallVibration();
    // 1) mark clicked
    final repo = ref.read(userNotificationRepositoryProvider);
    await repo.updateUserNotification(n.copyWith(clicked: true));

    switch (n.type) {
      case UserNotificationType.Comment:
        await _goToComment(context, ref, n.postId);
        break;
      case UserNotificationType.Follow:
        await _goToFollower(context, ref, n.senderId);
        break;
      case UserNotificationType.Unknown:
        break;
    }
  }

  Future<void> _goToComment(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    final postRepo = ref.read(postsRepositoryProvider);
    final post = await postRepo.getPostById(postId);
    if (post == null) {
      hardVibration();
      showCustomSnackbar(
        context,
        'profile_screen_error_follow_btn_text'.tr(),
        backgroundColor: colorNotOkButton,
      );
      return;
    }
    if (!context.mounted) return;
    pushToPostListScreen(context, postList: [post], searched: post.title);
  }

  Future<void> _goToFollower(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final userRepo = ref.read(usersRepositoryProvider);
    final user = await userRepo.getUserById(userId);
    if (user == null) {
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
  }

  Future<void> _markAllAsRead() async {
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return;

    mediumVibration();

    final repo = ref.read(userNotificationRepositoryProvider);
    final notifier = ref.read(loadUserNotificationsProvider.notifier);
    final currentList =
        ref.read(loadUserNotificationsProvider).userNotifications;

    // Update all unread notifications in parallel
    final futures = currentList
        .where((n) => n.receiverId == signedInUser.id && !n.clicked)
        .map((n) => repo.updateUserNotification(n.copyWith(clicked: true)));
    await Future.wait(futures);

    // Reload the notifications
    await notifier.getUserNotifications(signedInUser.id, false);

    ref.read(userNotificationUnreadProvider.notifier).update((state) => 0);
  }
}
