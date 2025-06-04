// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView>
    with ScrollHideTabBarBaseScreen<HomeView> {
  @override
  void initState() {
    super.initState();
    Future(() {
      _loadFriendsPosts();
    });
  }

  Future<void> _loadFriendsPosts() async {
    final signedInUser = ref.read(signedInUserProvider);
    final loadUsersNotifier = ref.read(loadSignedInFriendsProvider.notifier);
    final authStatus = ref.read(authStatusProvider).authStatus;
    // TODO: Edit this line later on...
    if (authStatus != AuthStatus.authenticated) return;
    if (signedInUser != null &&
        (signedInUser.isEmpty || signedInUser.friends.isEmpty)) {
      logger.d('Reloading Home Posts...');
      await loadUsersNotifier.loadUserSignedInUserFriends().then((friends) {
        ref
            .read(signedInUserProvider.notifier)
            .update((state) => signedInUser.copyWith(friends: friends));
      });
    }
    final loadPostsNotifier = ref.read(loadPostsProvider.notifier);
    loadPostsNotifier.loadPostedByMe();
    loadPostsNotifier.loadPostedByFriendsId();
  }

  @override
  Widget build(BuildContext context) {
    final signedInUser = ref.watch(signedInUserProvider);
    final postsProvider = ref.watch(loadPostsProvider);
    final size = MediaQuery.sizeOf(context);
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
        appBar: PreferredSize(
          preferredSize: Size(size.width, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HomeAppBar(
              onSearchPressed: () => pushToHomeSearchScreem(context),
              onProfileIconPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _loadFriendsPosts();
          },
          child: ListView.builder(
            controller: scrollController, // ← from the mixin
            itemCount: postsProvider.postedByFriends.length,
            itemBuilder: (_, i) {
              final post = postsProvider.postedByFriends[i];
              final currentUserId = signedInUser?.id;
              final currentUserReaction =
                  (currentUserId != null)
                      ? post.reactions[currentUserId]
                      : null;

              return ref
                  .watch(userFutureByIdProvider(post.createdById))
                  .when(
                    data:
                        (user) =>
                            user != null
                                ? ReactionablePostWidget(
                                  isLiked: false,
                                  post: post,
                                  author: user,
                                  reaction: currentUserReaction,
                                  onCommunityTapped:
                                      () => _actionCommunityTap(post.postedIn),
                                  onUserInfoTapped:
                                      () => pushToProfileScreen(
                                        context,
                                        user: user,
                                      ),
                                  onReaction:
                                      (reaction) =>
                                          updatePostActionWithReaction(
                                            post,
                                            reaction,
                                            ref,
                                          ),
                                  onContextMenuTap:
                                      (menuItem) =>
                                          handleContextMenuPostItemAction(
                                            ref,
                                            menuItem,
                                            post,
                                          ),
                                  onCommentTapped: () {
                                    showCustomBottomSheet(
                                      context,
                                      child: CommentsScreen(
                                        post: post,
                                        comments: post.comments,
                                        onPostComment: (
                                          postId,
                                          commentText,
                                        ) async {
                                          logger.i(
                                            'Comment on: $postId - $commentText',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                                : Text('User not found'),
                    error:
                        (error, stackTrace) =>
                            Text('Error while loading user: $error'),
                    loading: () => LoadingDefaultWidget(),
                  );
            },
          ),
        ),
      ),
    );
  }

  void _showAddPostOrCommunitySheet() {
    showNavigatableSheet(context, child: CreatePostOrCommunityScreen());
  }

  Future<void> _actionCommunityTap(String? postedIn) async {
    logger.i('Community: $postedIn');
    if (postedIn == null) return;
    final loadCommunity = ref.read(loadCommunitiesProvider.notifier);
    loadCommunity.loadUsersCommunityByTitle(postedIn).then((communities) {
      if (communities == null || communities.isEmpty) return;
      logger.i('Community: ${communities.first}');
      pushToCommunityScreen(context, community: communities.first);
    });
  }
}
