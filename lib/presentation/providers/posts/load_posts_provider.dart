// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
