// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final loadPostsProvider =
    StateNotifierProvider<LoadPostsNotifier, LoadPostsState>((ref) {
      final postsRepo = ref.watch(postsRepositoryProvider);
      final signedInUser = ref.watch(signedInUserProvider) ?? User.empty();
      final postsNotifier = LoadPostsNotifier(postsRepo, signedInUser);
      return postsNotifier;
    });

class LoadPostsNotifier extends StateNotifier<LoadPostsState> {
  final PostsRepository _postsRepository;
  final User _signedInUser;

  LoadPostsNotifier(this._postsRepository, this._signedInUser)
    : super(LoadPostsState());

  Future<List<Post>> loadPostedByFriendsId() async {
    if (state.isLoadingPostedByFriends) return state.postedByFriends;
    state = state.copyWith(isLoadingPostedByFriends: true);
    final postsByFriends = await _postsRepository.getPostsUsingUsersIdListRef(
      _signedInUser.friends,
    );
    logger.i('Posted by friends: ${postsByFriends.first.createdById}');
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
}

class LoadPostsState {
  final List<Post> postedByFriends;
  final List<Post> postedInCommunities;
  final bool isLoadingPostedByFriends;
  final bool isLoadingPostedByCommunities;

  LoadPostsState({
    this.postedByFriends = const [],
    this.postedInCommunities = const [],
    this.isLoadingPostedByFriends = false,
    this.isLoadingPostedByCommunities = false,
  });

  @override
  bool operator ==(covariant LoadPostsState other) {
    if (identical(this, other)) return true;

    return listEquals(other.postedByFriends, postedByFriends) &&
        listEquals(other.postedInCommunities, postedInCommunities) &&
        other.isLoadingPostedByFriends == isLoadingPostedByFriends &&
        other.isLoadingPostedByCommunities == isLoadingPostedByCommunities;
  }

  @override
  int get hashCode {
    return postedByFriends.hashCode ^
        postedInCommunities.hashCode ^
        isLoadingPostedByFriends.hashCode ^
        isLoadingPostedByCommunities.hashCode;
  }

  LoadPostsState copyWith({
    List<Post>? postedByFriends,
    List<Post>? postedInCommunities,
    bool? isLoadingPostedByFriends,
    bool? isLoadingPostedByCommunities,
  }) {
    return LoadPostsState(
      postedByFriends: postedByFriends ?? this.postedByFriends,
      postedInCommunities: postedInCommunities ?? this.postedInCommunities,
      isLoadingPostedByFriends:
          isLoadingPostedByFriends ?? this.isLoadingPostedByFriends,
      isLoadingPostedByCommunities:
          isLoadingPostedByCommunities ?? this.isLoadingPostedByCommunities,
    );
  }
}
