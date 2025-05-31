// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/model/menu_item.dart';
import 'package:flutter_chat_reactions/utilities/default_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/domain/models/models.dart';
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
                                          _handleContextMenuPostItemAction(
                                            menuItem,
                                            post,
                                          ),
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

  void _handleContextMenuPostItemAction(MenuItem item, Post post) {
    switch (item) {
      case DefaultData.copy:
        _copyPostAction(post);
      case DefaultData.delete:
        _deletePostAction(post);
    }
  }

  void _copyPostAction(Post post) {
    final clipboard = ref.read(clipboardProvider);
    clipboard.copy(post.title + post.content);
    smallVibration();
    showCustomSnackbar(
      context,
      'post_text_copied_success_snackbar_text'.tr(),
      backgroundColor: colorSuccess,
    );
  }

  void _deletePostAction(Post post) {
    final postsNotifier = ref.read(loadPostsProvider.notifier);
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

      /*ref
          .read(signedInUserProvider.notifier)
          .update(
            (state) =>
                state?.copyWith(posted: newPosts.map((p) => p.id).toList()),
          );*/

      smallVibration();
      showCustomSnackbar(
        context,
        'post_delete_success_snackbar_text'.tr(args: [post.title]),
        backgroundColor: colorSuccess,
      );
    });
  }
}
