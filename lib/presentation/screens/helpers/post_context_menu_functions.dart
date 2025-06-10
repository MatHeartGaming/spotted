// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/model/menu_item.dart';
import 'package:flutter_chat_reactions/utilities/default_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

void handleContextMenuPostItemAction(WidgetRef ref, MenuItem item, Post post) {
  switch (item) {
    case DefaultData.copy:
      _copyPostAction(ref, post);
    case DefaultData.delete:
      _deletePostAction(ref, post);
    case DefaultData.reply:
      _openCommentsScreen(ref.context, post);
  }
}

void _copyPostAction(WidgetRef ref, Post post) {
  final context = ref.context;
  final clipboard = ref.read(clipboardProvider);
  clipboard.copy(post.title + post.content);
  smallVibration();
  showCustomSnackbar(
    context,
    'post_text_copied_success_snackbar_text'.tr(),
    backgroundColor: colorSuccess,
  );
}

void _openCommentsScreen(BuildContext context, Post post) {
  showCustomBottomSheet(
    context,
    child: CommentsScreen(
      post: post,
      comments: post.comments,
      onPostComment: (postId, commentText) async {
        logger.i('Comment on: $postId - $commentText');
      },
    ),
  );
}

void _deletePostAction(WidgetRef ref, Post post) {
  final context = ref.context;
  final postsNotifier = ref.read(loadPostsProvider.notifier);
  final communitiesNotifier = ref.read(loadCommunitiesProvider.notifier);
  final usersRepo = ref.read(usersRepositoryProvider);
  final signedInUser = ref.read(signedInUserProvider);
  if (signedInUser == null) return;
  postsNotifier.deletePostById(post.id).then((newPosts) {
    if (newPosts == null) {
      hardVibration();
      showCustomSnackbar(
        context,
        'post_delete_error_snackbar_text'.tr(),
        backgroundColor: colorNotOkButton,
      );
      return;
    }

    if (post.postedIn != null) {
      communitiesNotifier.removePost(post.postedIn!, post.id);
    }
    usersRepo.removePost(signedInUser.id, post.id);
    ref
        .read(signedInUserProvider.notifier)
        .update(
          (state) =>
              state?.copyWith(posted: newPosts.map((p) => p.id).toList()),
        );

    smallVibration();
    showCustomSnackbar(
      context,
      'post_delete_success_snackbar_text'.tr(args: [post.title]),
      backgroundColor: colorSuccess,
    );
  });
}
