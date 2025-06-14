// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final Community community;
  const CommunityScreen({super.key, required this.community});

  @override
  CommunityScreenState createState() => CommunityScreenState();
}

class CommunityScreenState extends ConsumerState<CommunityScreen>
    with ScrollHideAppBarProfileCommunityScreenMixin<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    _initCommunityPosts();
  }

  Future<void> _initCommunityPosts() async {
    Future(() {
      final communityToUse = ref.read(communityScreenCurrentCommunityProvider);
      ref
          .read(loadPostsProvider.notifier)
          .loadPostsWithListRef(communityToUse.postsRefs)
          .then((posts) {
            ref
                .read(communityScreenCurrentCommunityProvider.notifier)
                .update((state) => communityToUse.copyWith(posts: posts));
          });
      ref
          .read(loadCommunitiesProvider.notifier)
          .loadAdmins(widget.community.admins);
    });
  }

  @override
  void didUpdateWidget(CommunityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      _initCommunityPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final texts = TextTheme.of(context);
    final signedInUser = ref.watch(signedInUserProvider);
    final communityToUse = ref.watch(communityScreenCurrentCommunityProvider);
    final isUserAdmin = communityToUse.admins.contains(signedInUser?.id);
    final loadCommunityState = ref.watch(loadCommunitiesProvider);
    if (communityToUse.isEmpty) {
      return LoadingDefaultWidget();
    }
    final notSubscribed =
        !(signedInUser?.communitiesSubs.contains(communityToUse.id) ?? false);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 1,
          onPressed: () => _openCreatePostSheet(),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Icon(Icons.edit),
              Text('create_post_list_tile_title').tr(),
            ],
          ),
        ),
        body: Stack(
          children: [
            NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      FadeInImage(
                        fit: BoxFit.cover,
                        height: 300,
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(communityToUse.pictureUrl ?? ''),
                      ),
                      SizedBox(height: 20),
                      FadeIn(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    communityToUse.title,
                                    style: texts.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    communityToUse.description,
                                    style: texts.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              Visibility(
                                visible: !isUserAdmin,
                                child: FilledButton(
                                  onPressed: () => _onSubscribeAction(),
                                  child:
                                      Text(
                                        notSubscribed
                                            ? 'community_screen_subscribe_text'
                                            : 'community_screen_unsubscribe_text',
                                      ).tr(),
                                ),
                              ),

                              Visibility(
                                visible: isUserAdmin,
                                child: IconButton.filledTonal(
                                  tooltip:
                                      'create_community_screen_edit_community_btn_text'
                                          .tr(),
                                  onPressed:
                                      () => pushToCreateCommunityScreen(
                                        context,
                                        community: communityToUse,
                                      ),
                                  icon: Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Text(
                          'admin_text',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ).tr(
                          args: [loadCommunityState.admins.length.toString()],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: HorizontalUsersList(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          usersList: loadCommunityState.admins,
                          onItemTap:
                              (user) =>
                                  pushToProfileScreen(context, user: user),
                          sectionItemBuilder: (u) {
                            return _AdminItem(user: u);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ]),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () => _initCommunityPosts(),
                child: PostsListView(
                  posts: communityToUse.posts,
                  onCommunityTap: (post) => {},
                  onProfileTap:
                      (user) => pushToProfileScreen(context, user: user),
                  onReaction: (post, reaction) async {
                    await updatePostActionWithReaction(
                      post,
                      reaction,
                      ref,
                    ).then((value) {
                      _initCommunityPosts();
                    });
                  },
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

            Positioned(
              top: topPadding,
              left: 16,
              right: 16,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(
                  0,
                  isScrollingDown ? -100 : 0,
                  0,
                ),
                child: ProfileAppBar(
                  onBackTapped: () => context.pop(),
                  onMessageTapped: () => {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreatePostSheet() {
    showCustomBottomSheet(
      context,
      child: CreatePostsScreen(communityId: widget.community.id),
    );
  }

  void _onSubscribeAction() {
    final signedInUser = ref.read(signedInUserProvider);
    if (signedInUser == null || signedInUser.isEmpty) return;

    final signedInUserNotifier = ref.read(signedInUserProvider.notifier);
    final userRepo = ref.read(usersRepositoryProvider);
    final loadCommunities = ref.read(loadCommunitiesProvider.notifier);

    final commId = widget.community.id;
    final userId = signedInUser.id;

    // If not already subscribed → add subscription
    if (!signedInUser.communitiesSubs.contains(commId)) {
      loadCommunities.addSub(commId, userId).then((addSubSuccess) {
        if (!addSubSuccess) return;

        // Update community locally
        loadCommunities.updateCommunityLocally(
          widget.community.copyWith(
            subscribed: [userId, ...widget.community.subscribed],
          ),
        );

        // Persist to user repo
        userRepo.addSub(userId, commId).then((success) {
          if (!success) return;
          // Update signed-in user state
          final updatedUser = signedInUser.copyWith(
            communitiesSubs: [commId, ...signedInUser.communitiesSubs],
          );
          signedInUserNotifier.update((_) => updatedUser);
        });
      });
    }
    // Already subscribed → remove subscription
    else {
      loadCommunities.removeSub(commId, userId).then((removeSubSuccess) {
        if (!removeSubSuccess) return;

        // Update community locally
        loadCommunities.updateCommunityLocally(
          widget.community.copyWith(
            subscribed:
                widget.community.subscribed
                    .where((id) => id != userId)
                    .toList(),
          ),
        );

        // Persist removal in user repo
        userRepo.removeSub(userId, commId).then((success) {
          if (!success) return;
          // Update signed-in user state
          final updatedUser = signedInUser.copyWith(
            communitiesSubs:
                signedInUser.communitiesSubs
                    .where((id) => id != commId)
                    .toList(),
          );
          signedInUserNotifier.update((_) => updatedUser);
        });
      });
    }
  }
}

class _AdminItem extends StatelessWidget {
  final UserModel user;

  const _AdminItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 4,
        children: [
          CirclePicture(urlPicture: user.profileImageUrl, width: 30),
          Text(user.atUsername),
        ],
      ),
    );
  }
}
