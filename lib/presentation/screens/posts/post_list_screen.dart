import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class PostListScreen extends ConsumerStatefulWidget {
  static const name = 'PostListScreen';
  final List<Post> postList;
  final String? searched;

  const PostListScreen({required this.postList, this.searched, super.key});

  @override
  PostListScreenState createState() => PostListScreenState();
}

class PostListScreenState extends ConsumerState<PostListScreen> {
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = List.from(widget.postList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'post_list_screen_app_bar_title',
        ).tr(args: [widget.searched ?? '']),
      ),
      body: PostsListView(
        posts: _posts,
        onCommunityTap: (post) => actionCommunityTap(ref, post.postedIn),
        onProfileTap: (user) => pushToProfileScreen(context, user: user),
        onReaction: (post, reaction) => _reactionAction(post, reaction),
        onContextMenu:
            (post, item) => handleContextMenuPostItemAction(ref, item, post),
        onComment: (post) {
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
        },
      ),
    );
  }

  void _reactionAction(Post post, String reaction) {
    final currentUser = ref.watch(signedInUserProvider);
    final currentUserId = currentUser?.id;
    if (currentUserId == null) return;

    // 1) Compute the new reactions map locally (same as your data layer does)
    final newReactions = _toggleReaction(
      post.reactions,
      currentUserId,
      reaction,
    );
    final updatedPost = post.copyWith(reactions: newReactions);

    // 2) Update UI immediately
    setState(() {
      final idx = _posts.indexWhere((p) => p.id == post.id);
      if (idx != -1) _posts[idx] = updatedPost;
    });

    // 3) Fire‐and‐forget the real update
    updatePostActionWithReaction(post, reaction, ref);
  }

  Map<String, String> _toggleReaction(
    Map<String, String> map,
    String userId,
    String reaction,
  ) {
    final copy = Map<String, String>.from(map);
    if (reaction == '👍') {
      if (copy.containsKey(userId)) {
        copy.remove(userId);
      } else {
        copy[userId] = '👍';
      }
    } else {
      final existing = copy[userId];
      if (existing == reaction) {
        copy.remove(userId);
      } else {
        copy[userId] = reaction;
      }
    }
    return copy;
  }
}
