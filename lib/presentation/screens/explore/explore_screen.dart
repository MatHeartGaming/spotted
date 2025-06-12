import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/comments/comments_screen.dart';
import 'package:spotted/presentation/screens/creation/create_post_or_community_screen.dart';
import 'package:spotted/presentation/screens/helpers/community_helper.dart';
import 'package:spotted/presentation/screens/helpers/post_context_menu_functions.dart';
import 'package:spotted/presentation/screens/helpers/reaction_functions.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  static const name = 'ExploreScreen';
  const ExploreScreen({super.key});
  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends ConsumerState<ExploreScreen>  with ScrollHideTabBarBaseScreen<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    Future(() {
      _loadCommunitiesPosts();
    });
  }

  Future<void> _loadCommunitiesPosts() async {
    final signedInUser = ref.read(signedInUserProvider);
    final loadUsersNotifier = ref.read(loadSignedInFriendsProvider.notifier);
    final authStatus = ref.read(authStatusProvider).authStatus;
    if (authStatus != AuthStatus.authenticated) return;
    if (signedInUser != null &&
        (signedInUser.isEmpty || signedInUser.friends.isEmpty)) {
      await loadUsersNotifier.loadUserSignedInUserFriends().then((friends) {
        ref
            .read(signedInUserProvider.notifier)
            .update((state) => signedInUser.copyWith(friends: friends));
      });
    }
    final loadPostsNotifier = ref.read(loadPostsProvider.notifier);
    loadPostsNotifier.loadPostedInCommunities();
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = ref.watch(loadPostsProvider);
    final hideAppbar = ref.watch(appBarVisibilityProvider);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: AnimatedOpacityFab(
          show: animateFabsOut,
          child: AddFab(
            onTap: () => _showAddPostOrCommunitySheet(),
            heroTag: 1,
            tooltip: 'add_fab_home_tooltip_text'.tr(),
          ),
        ),

        // We remove `appBar:` here and build our own “collapsible” bar inside the body.
        body: Column(
          children: [
            // 1. AnimatedContainer that shrinks height to 0 when `hideAppbar == true`.
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              // When hideAppbar is true, height=0. Otherwise 50 + top padding.
              height: hideAppbar ? 0 : 50,
              // Clip it so the HomeAppBar doesn’t overflow while collapsing.
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: hideAppbar ? 0 : 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 50,
                      child: HomeAppBar(
                        onSearchPressed: () => pushToHomeSearchScreem(context),
                        onProfileIconPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Expanded ListView: when AnimatedContainer height goes to 0, this expands upward.
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadCommunitiesPosts();
                },
                child: PostsListView(
                  posts: postsProvider.postedInCommunities,
                  scrollController: scrollController,
                  onCommunityTap: (post) => actionCommunityTap(ref, post.postedIn),
                  onProfileTap:
                      (user) => pushToProfileScreen(context, user: user),
                  onReaction:
                      (post, reaction) =>
                          updatePostActionWithReaction(post, reaction, ref),
                  onContextMenu:
                      (post, item) =>
                          handleContextMenuPostItemAction(ref, item, post),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPostOrCommunitySheet() {
    showNavigatableSheet(context, child: CreatePostOrCommunityScreen());
  }
}
