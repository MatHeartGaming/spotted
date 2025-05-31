// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final currentProfilePostsProvider = StateProvider.autoDispose<List<Post>>((
  ref,
) {
  return [];
});

final loadPostFutureProvider = FutureProvider.family<Post?, String>((
  ref,
  postId,
) async {
  final postRepo = ref.watch(postsRepositoryProvider);
  final post = await postRepo.getPostById(postId);
  return post;
});

final loadPostsProvider =
    StateNotifierProvider<LoadPostsNotifier, LoadPostsState>((ref) {
  final postsRepo = ref.watch(postsRepositoryProvider);
  // We do NOT call `ref.watch(signedInUserProvider)` here.
  // Instead, pass `ref` into the notifier so it can read the user on demand.
  return LoadPostsNotifier(ref, postsRepo);
});


class LoadPostsNotifier extends StateNotifier<LoadPostsState> {
  final Ref _ref; //! <–– In order to not trigger rebuilds of this Notifier and loose posts!!!
  final PostsRepository _postsRepository;

  LoadPostsNotifier(this._ref, this._postsRepository) : super(LoadPostsState());

  /// Helper: get the current signed-in user whenever we need it.
  User get _signedInUser {
    // We use `read` instead of `watch` to avoid rebuilding the notifier itself.
    return _ref.read(signedInUserProvider) ?? User.empty();
  }

  Future<List<Post>> loadPostedByFriendsId() async {
    if (state.isLoadingPostedByFriends) return state.postedByFriends;
    state = state.copyWith(isLoadingPostedByFriends: true);
    final postsByFriends = await _postsRepository.getPostsUsingUsersIdListRef(
      _signedInUser.friendsRefs,
    );
    state = state.copyWith(
      postedByFriends: postsByFriends,
      isLoadingPostedByFriends: false,
    );
    return postsByFriends;
  }

  Future<List<Post>> loadPostedInCommunities() async {
    if (state.isLoadingPostedByCommunities) return state.postedInCommunities;
    state = state.copyWith(isLoadingPostedByCommunities: true);
    final postsInCommunities = await _postsRepository.getPostsUsingPostedInList(
      _signedInUser.communitiesSubs,
    );
    state = state.copyWith(
      postedInCommunities: postsInCommunities,
      isLoadingPostedByCommunities: false,
    );
    return postsInCommunities;
  }

  Future<List<Post>> loadPostedByMe() async {
    if (state.isLoadingPostedByMe) return state.postedByMe;
    state = state.copyWith(isLoadingPostedByMe: true);
    final postedByMe = await _postsRepository.getPostsUsingUsersPostedIdList(
      _signedInUser.posted,
    );
    state = state.copyWith(postedByMe: postedByMe, isLoadingPostedByMe: false);
    return postedByMe;
  }

  Future<List<Post>> loadPostsWithListRef(List<String> postRefs) async {
    final postedByMe = await _postsRepository.getPostsUsingUsersPostedIdList(
      postRefs,
    );
    return postedByMe;
  }

  Future<Post?> updatePost(Post updatedPost) async {
    final newPost = await _postsRepository.updatePost(updatedPost);
    if (newPost != null) {
      // 1) Replace in postedByFriends
      final updatedFriendsList =
          state.postedByFriends
              .map((p) => p.id == newPost.id ? newPost : p)
              .toList();

      // 2) Replace in postedInCommunities
      final updatedCommunitiesList =
          state.postedInCommunities
              .map((p) => p.id == newPost.id ? newPost : p)
              .toList();

      // 3) Emit new state
      state = state.copyWith(
        postedByFriends: updatedFriendsList,
        postedInCommunities: updatedCommunitiesList,
      );
    }
    return newPost;
  }

  Future<Post?> createPost(Post updatedPost) async {
    final newPost = await _postsRepository.createPost(updatedPost);
    if (newPost == null) return null;

    // 3) Emit new state
    state = state.copyWith(
      postedByFriends: [newPost, ...state.postedByFriends],
      //postedInCommunities: updatedCommunitiesList,
    );
    return newPost;
  }

  Future<List<Post>?> deletePostById(String id) async {
    if (state.isLoadingPostedByMe) return state.postedByMe;
    state = state.copyWith(isLoadingPostedByMe: true);
    final List<Post> newPosts = await _postsRepository.deletePostById(id);

    final postedByFriends = state.postedByFriends;
    postedByFriends.removeWhere((p) => p.id == id);

    state = state.copyWith(
      isLoadingPostedByMe: false,
      postedByMe: newPosts,
      postedByFriends: postedByFriends,
    );
    return newPosts;
  }
}

class LoadPostsState {
  final List<Post> postedByFriends;
  final List<Post> postedInCommunities;
  final List<Post> postedByMe;
  final bool isLoadingPostedByFriends;
  final bool isLoadingPostedByCommunities;
  final bool isLoadingPostedByMe;

  LoadPostsState({
    this.postedByFriends = const [],
    this.postedInCommunities = const [],
    this.postedByMe = const [],
    this.isLoadingPostedByFriends = false,
    this.isLoadingPostedByCommunities = false,
    this.isLoadingPostedByMe = false,
  });

  @override
  bool operator ==(covariant LoadPostsState other) {
    if (identical(this, other)) return true;

    return listEquals(other.postedByFriends, postedByFriends) &&
        listEquals(other.postedInCommunities, postedInCommunities) &&
        listEquals(other.postedByMe, postedByMe) &&
        other.isLoadingPostedByFriends == isLoadingPostedByFriends &&
        other.isLoadingPostedByCommunities == isLoadingPostedByCommunities &&
        other.isLoadingPostedByMe == isLoadingPostedByMe;
  }

  @override
  int get hashCode {
    return postedByFriends.hashCode ^
        postedInCommunities.hashCode ^
        postedByMe.hashCode ^
        isLoadingPostedByFriends.hashCode ^
        isLoadingPostedByCommunities.hashCode ^
        isLoadingPostedByMe.hashCode;
  }

  LoadPostsState copyWith({
    List<Post>? postedByFriends,
    List<Post>? postedInCommunities,
    List<Post>? postedByMe,
    bool? isLoadingPostedByFriends,
    bool? isLoadingPostedByCommunities,
    bool? isLoadingPostedByMe,
  }) {
    return LoadPostsState(
      postedByFriends: postedByFriends ?? this.postedByFriends,
      postedInCommunities: postedInCommunities ?? this.postedInCommunities,
      postedByMe: postedByMe ?? this.postedByMe,
      isLoadingPostedByFriends:
          isLoadingPostedByFriends ?? this.isLoadingPostedByFriends,
      isLoadingPostedByCommunities:
          isLoadingPostedByCommunities ?? this.isLoadingPostedByCommunities,
      isLoadingPostedByMe: isLoadingPostedByMe ?? this.isLoadingPostedByMe,
    );
  }
}
