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
    return Scaffold(
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
                onCommunityTapped: () => _actionCommunityTap(ref, post.postedIn),
                onUserInfoTapped:
                    () => pushToProfileScreen(context, user: widget.user),
                onReaction: (reaction) async {
                  await updatePostActionWithReaction(post, reaction, ref).then((
                    value,
                  ) {
                    _initUserPosts();
                  });
                },
                onContextMenuTap: (menuItem) {},
              );
            },
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
      // ignore: use_build_context_synchronously
      pushToCommunityScreen(ref.context, community: communities.first);
    });
  }
}
