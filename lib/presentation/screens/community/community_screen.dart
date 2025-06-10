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
    if (communityToUse.isEmpty) {
      return LoadingDefaultWidget();
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
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
                                visible:
                                    !isUserAdmin &&
                                    !(signedInUser?.communitiesSubs.contains(
                                          communityToUse.id,
                                        ) ??
                                        false),
                                child: FilledButton(
                                  onPressed: () {},
                                  child:
                                      Text(
                                        'community_screen_subscribe_text',
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
                      SizedBox(height: 20),
                    ]),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () => _initCommunityPosts(),
                child: ListView.builder(
                  itemCount: communityToUse.posts.length,
                  itemBuilder: (context, index) {
                    final post = communityToUse.posts[index];
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
                                        author: user,
                                        post: post,
                                        reaction: currentUserReaction,
                                        onCommunityTapped:
                                            () => _actionCommunityTap(
                                              ref,
                                              post.postedIn,
                                            ),
                                        onUserInfoTapped:
                                            () => pushToProfileScreen(
                                              context,
                                              user: user,
                                            ),
                                        onReaction: (reaction) async {
                                          await updatePostActionWithReaction(
                                            post,
                                            reaction,
                                            ref,
                                          ).then((value) {
                                            _initCommunityPosts();
                                          });
                                        },
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
                                        onContextMenuTap:
                                            (menuItem) =>
                                                handleContextMenuPostItemAction(
                                                  ref,
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

  Future<void> _actionCommunityTap(WidgetRef ref, String? postedIn) async {
    logger.i('Community: $postedIn');
    if (postedIn == null) return;
    final loadCommunity = ref.read(loadCommunitiesProvider.notifier);
    loadCommunity.loadUsersCommunityByTitle(postedIn).then((communities) {
      if (communities == null || communities.isEmpty) return;
      logger.i('Community: ${communities.first}');
      pushToCommunityScreen(ref.context, community: communities.first);
    });
  }

  void _openCreatePostSheet() {
    showCustomBottomSheet(
      context,
      child: CreatePostsScreen(communityId: widget.community.id),
    );
  }
}
