import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/model/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

typedef CommunityTapCallback = void Function(Post post);
typedef UserTapCallback = void Function(UserModel user);
typedef ReactionCallback = FutureOr<void> Function(Post post, String reaction);
typedef ContextMenuCallback = void Function(Post post, MenuItem item);
typedef CommentTapCallback = void Function(Post post);

class PostsListView extends ConsumerWidget {
  final List<Post> posts;
  final ScrollController? scrollController;
  final CommunityTapCallback onCommunityTap;
  final UserTapCallback onProfileTap;
  final ReactionCallback onReaction;
  final ContextMenuCallback onContextMenu;
  final CommentTapCallback onComment;
  final double bottomListViewPadding;

  const PostsListView({
    super.key,
    required this.posts,
    this.scrollController,
    required this.onCommunityTap,
    required this.onProfileTap,
    required this.onReaction,
    required this.onContextMenu,
    required this.onComment,
    this.bottomListViewPadding = 100,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInUser = ref.watch(signedInUserProvider);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(bottom: bottomListViewPadding),
      itemCount: posts.length,
      itemBuilder: (_, i) {
        final post = posts[i];
        final currUid = signedInUser?.id;
        final currReaction = currUid == null ? null : post.reactions[currUid];

        return ref
            .watch(userFutureByIdProvider(post.createdById))
            .when(
              data: (user) {
                if (user == null) {
                  return const Text('User not found');
                }
                return ReactionablePostWidget(
                  post: post,
                  author: user,
                  reaction: currReaction,
                  onCommunityTapped: () => onCommunityTap(post),
                  onUserInfoTapped: () => onProfileTap(user),
                  onReaction: (r) => onReaction(post, r),
                  onContextMenuTap: (item) => onContextMenu(post, item),
                  onCommentTapped: () => onComment(post),
                );
              },
              loading: () => const LoadingDefaultWidget(),
              error: (e, st) => Text('Error loading user: $e'),
            );
      },
    );
  }
}
