// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _initUserPosts();
  }

  Future<void> _initUserPosts() async {
    Future.delayed(Duration.zero, () {
      ref
          .read(loadPostsProvider.notifier)
          .loadPostedByUserListRef(widget.user.posted)
          .then((postList) {
            ref
                .read(currentProfilePostsProvider.notifier)
                .update((state) => postList);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = TextTheme.of(context);
    final usersPost = ref.watch(currentProfilePostsProvider);
    final signedInUser = ref.watch(signedInUserProvider);
    final isUserYou = signedInUser == widget.user;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_hasChanged) {
          ref.read(loadPostsProvider.notifier).loadPostedByFriendsId();
        }
      },
      child: Scaffold(
        body: NestedScrollView(
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
                                    (signedInUser ?? User.empty()).friends
                                            .contains(widget.user.id)
                                        ? 'profile_screen_stop_follow_btn_text'
                                        : widget.user.friends.contains(
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
                                    'profile_screen_edit_profile_btn_text'.tr(),
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ChipsGridView(
                    chips: widget.user.features,
                    onTap: (label) {},
                    showDeleteIcon: isUserYou,
                    onDelete: () {},
                  ),
                ]),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () => _initUserPosts(),
            child: ListView.builder(
              itemCount: usersPost.length,
              itemBuilder: (context, index) {
                final post = usersPost[index];
                return ReactionablePostWidget(
                  isLiked: false,
                  author: widget.user,
                  post: post,
                  onCommunityTapped:
                      () => _actionCommunityTap(ref, post.postedIn),
                  onUserInfoTapped:
                      () => pushToProfileScreen(context, user: widget.user),
                  onReaction: (reaction) async {
                    await updatePostActionWithReaction(
                      post,
                      reaction,
                      ref,
                    ).then((value) {
                      _initUserPosts();
                    });
                  },
                  onContextMenuTap: (menuItem) {},
                );
              },
            ),
          ),
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

  void _onFollowTapped() {
    final signedInUser = ref.read(signedInUserProvider);
    final isUserYou = signedInUser == widget.user;
    if (isUserYou) return;
    final usersNotifier = ref.read(loadUserProvider.notifier);
    usersNotifier.addOrRemoveFriend(widget.user.id).then((updatedFriendsInfos) {
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
      ref.read(signedInUserProvider.notifier).update((state) => updatedUser);
      _hasChanged = true;
    });
  }
}
