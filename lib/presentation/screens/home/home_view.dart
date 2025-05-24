import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final postsProvider = ref.watch(loadPostsProvider);
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
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
                                  post: post,
                                  author: user,
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
}
