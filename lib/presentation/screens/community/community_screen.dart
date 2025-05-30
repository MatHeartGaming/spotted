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
      ref
          .read(loadPostsProvider.notifier)
          .loadPostsWithListRef(widget.community.postsRefs)
          .then((posts) {
            ref
                .read(communityScreenCurrentCommunityProvider.notifier)
                .update((state) => widget.community.copyWith(posts: posts));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final texts = TextTheme.of(context);
    final signedInUser = ref.watch(signedInUserProvider);
    final community = ref.watch(communityScreenCurrentCommunityProvider);
    final isUserAdmin = community.admins.contains(signedInUser?.username);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
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
                        image: NetworkImage(community.pictureUrl ?? ''),
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
                                    community.title,
                                    style: texts.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    community.description,
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
                                          community.title,
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
                                      'profile_screen_edit_profile_btn_text'
                                          .tr(),
                                  onPressed:
                                      () => pushToCreateCommunityScreen(
                                        context,
                                        community: community,
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
                  itemCount: community.posts.length,
                  itemBuilder: (context, index) {
                    final post = community.posts[index];
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
                                        onContextMenuTap: (menuItem) {},
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
}
