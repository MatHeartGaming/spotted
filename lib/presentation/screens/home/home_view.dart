import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
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
            onTap: () {},
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
                                  onReaction:
                                      (reaction) =>
                                          _updatePostActionWithReaction(
                                            post,
                                            reaction,
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

  void _updatePostActionWithReaction(Post post, String reaction) {
    final loadPostsNotifier = ref.read(loadPostsProvider.notifier);
    final signedInUser = ref.read(signedInUserProvider);
    final userId = signedInUser?.id;
    if (userId == null) return;

    // Start from the existing reactions
    final newReactions = Map<String, String>.from(post.reactions);

    // If they tapped the same reaction again, remove it; otherwise set/update it
    if (newReactions[userId] == reaction) {
      newReactions.remove(userId);
    } else {
      newReactions[userId] = reaction;
    }

    final updatedPost = post.copyWith(reactions: newReactions);
    loadPostsNotifier.updatePost(updatedPost).then((post) {
      // TODO: Update user with the reaction
      if (post != null) {}
    });
  }
}
