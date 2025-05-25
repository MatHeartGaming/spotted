import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    Future.delayed(Duration.zero, () {
      _loadFriendsPosts();
    });
  }

  void _loadFriendsPosts() {
    ref.read(loadPostsProvider.notifier).loadPostedByFriendsId();
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
    );
  }

  void _showAddPostOrCommunitySheet() {
    showNavigatableSheet(context, child: CreatePostOrCommunityScreen());
  }
}
