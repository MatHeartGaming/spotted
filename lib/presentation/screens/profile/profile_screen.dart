// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen>
    with ScrollHideAppBarProfileCommunityScreenMixin<ProfileScreen> {
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _initUserInfos();
  }

  Future<void> _initUserInfos() async {
    Future(() {
      ref
          .read(loadPostsProvider.notifier)
          .loadPostsWithListRef(widget.user.posted)
          .then((postList) {
            ref
                .read(currentProfilePostsProvider.notifier)
                .update((state) => postList);
          });

      final signedInUser = ref.read(signedInUserProvider);
      if (signedInUser == null) return;
      final isOtherUserProfile = signedInUser != widget.user;
      ref.read(editProfileFormProvider.notifier).initFormField(signedInUser);
      ref
          .read(featureRepositoryProvider)
          .getFeaturesByIds(
            isOtherUserProfile
                ? widget.user.featureRefs
                : signedInUser.featureRefs,
          )
          .then((features) {
            ref
                .read(assignedFeaturesProvider.notifier)
                .update((state) => features);
          });
      ref
          .read(interestsRepositoryProvider)
          .getInterestsByIds(
            isOtherUserProfile
                ? widget.user.interestsRefs
                : signedInUser.interestsRefs,
          )
          .then((interests) {
            ref
                .read(assignedInterestProvider.notifier)
                .update((state) => interests);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final texts = TextTheme.of(context);
    final usersPost = ref.watch(currentProfilePostsProvider);
    final signedInUser = ref.watch(signedInUserProvider);
    final assignedInterests = ref.watch(assignedInterestProvider);
    final assignedFeatures = ref.watch(assignedFeaturesProvider);
    final assignedFeatureNames = assignedFeatures.map((f) => f.name).toSet();
    final assignedInterestsNames = assignedInterests.map((f) => f.name).toSet();
    final isUserYou = signedInUser == widget.user;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_hasChanged) {
          ref.read(loadPostsProvider.notifier).loadPostedByFriendsId();
        }
      },
      child: Scaffold(
        floatingActionButton: AddFab(
          onTap: () => _showAddPostOrCommunitySheet(),
          heroTag: 1,
          tooltip: 'add_fab_home_tooltip_text'.tr(),
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
                        image: NetworkImage(widget.user.profileImageUrl),
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
                                    widget.user.completeName,
                                    style: texts.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.user.atUsername,
                                    style: texts.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              Visibility(
                                visible: !isUserYou,
                                child: FilledButton(
                                  onPressed: () => _onFollowTapped(),
                                  child:
                                      Text(
                                        (signedInUser ?? User.empty())
                                                .friendsRefs
                                                .contains(widget.user.id)
                                            ? 'profile_screen_stop_follow_btn_text'
                                            : widget.user.friendsRefs.contains(
                                              signedInUser?.id,
                                            )
                                            ? 'profile_screen_follow_you_too_btn_text'
                                            : 'profile_screen_follow_btn_text',
                                      ).tr(),
                                ),
                              ),

                              if (isUserYou)
                                Visibility(
                                  visible: isUserYou,
                                  child: IconButton.filledTonal(
                                    tooltip:
                                        'profile_screen_edit_profile_btn_text'
                                            .tr(),
                                    onPressed:
                                        () => pushToEditProfileScreem(context),
                                    icon: Icon(Icons.edit),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Text(
                          'edit_info_screen_your_features_text',
                          style: texts.bodySmall,
                        ).tr(args: [assignedFeatureNames.length.toString()]),
                      ),
                      ChipsGridView(
                        chips: assignedFeatureNames.toList(),
                        onTap: (label) {},
                        showDeleteIcon: false,
                        spacing: 0,
                        onDelete: () {},
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Text(
                          'edit_info_screen_your_interests_text',
                          style: texts.bodySmall,
                        ).tr(args: [assignedInterestsNames.length.toString()]),
                      ),
                      ChipsGridView(
                        chips: assignedInterestsNames.toList(),
                        onTap: (label) {},
                        showDeleteIcon: false,
                        spacing: 0,
                        onDelete: () {},
                      ),
                    ]),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () => _initUserInfos(),
                child: PostsListView(
                  bottomListViewPadding: 110,
                  posts: usersPost,
                  onCommunityTap:
                      (post) => actionCommunityTap(ref, post.postedIn),
                  onProfileTap:
                      (user) => pushToProfileScreen(context, user: user),
                  onReaction: (post, reaction) async {
                    await updatePostActionWithReaction(
                      post,
                      reaction,
                      ref,
                    ).then((value) {
                      _initUserInfos();
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
                  onMessageTapped: () => pushToChatsScreen(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFollowTapped() {
    final signedInUser = ref.read(signedInUserProvider);
    final isUserYou = signedInUser == widget.user;
    if (isUserYou) return;
    final signedInuserFriendsNotifier = ref.read(
      loadSignedInFriendsProvider.notifier,
    );
    signedInuserFriendsNotifier
        .addOrRemoveSignedInUserFriend(widget.user.id)
        .then((updatedFriendsInfos) {
          final updatedUser = updatedFriendsInfos.$1;
          final isAdd = updatedFriendsInfos.$2;
          if (updatedUser == null) {
            hardVibration();
            showCustomSnackbar(
              context,
              'profile_screen_error_follow_btn_text'.tr(),
              backgroundColor: colorNotOkButton,
            );
            return;
          }
          if (isAdd) {
            showCustomSnackbar(
              context,
              'profile_screen_success_follow_btn_text'.tr(
                args: [widget.user.username],
              ),
              backgroundColor: colorSuccess,
            );
          } else {
            showCustomSnackbar(
              context,
              'profile_screen_success_unfollow_btn_text'.tr(
                args: [widget.user.username],
              ),
              backgroundColor: colorSuccess,
            );
          }
          ref
              .read(signedInUserProvider.notifier)
              .update((state) => updatedUser);
          _hasChanged = true;
        });
  }

  void _showAddPostOrCommunitySheet() {
    showNavigatableSheet(context, child: CreatePostOrCommunityScreen());
  }
}
