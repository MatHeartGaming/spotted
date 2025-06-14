// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/datasources/datasources.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final communityScreenCurrentCommunityProvider =
    StateProvider.autoDispose<Community>((ref) {
      return Community.empty();
    });

final loadCommunitiesProvider =
    StateNotifierProvider<LoadCommunitiesNotifier, LoadCommunitiesState>((ref) {
      final communityRepo = ref.watch(communityRepositoryProvider);
      final signedInUser = ref.watch(signedInUserProvider);
      final loadCommunityNotifier = LoadCommunitiesNotifier(
        communityRepo,
        signedInUser ?? UserModel.empty(),
      );
      return loadCommunityNotifier;
    });

class LoadCommunitiesNotifier extends StateNotifier<LoadCommunitiesState> {
  final CommunityRepository _communityRepository;
  final UserModel _signedInUser;

  LoadCommunitiesNotifier(this._communityRepository, this._signedInUser)
    : super(LoadCommunitiesState());

  Future<List<Community>?> loadUsersCommunities() async {
    if (state.isLoadingUsersCommunities) return state.usersCommunities;
    state = state.copyWith(isLoadingUsersCommunities: true);

    final usersCommmunity = await _communityRepository
        .getCommunitiesUsingUsersCommunityIdList(_signedInUser.communitiesSubs);

    state = state.copyWith(
      isLoadingUsersCommunities: false,
      usersCommunities: usersCommmunity,
    );

    return usersCommmunity;
  }

  Future<Community?> loadUsersCommunityById(String id) async {
    final community = await _communityRepository.getCommunityById(id);
    return community;
  }

  Future<List<Community>?> loadUsersCommunityByTitle(String title) async {
    final commmunities = await _communityRepository.getCommunitiesByTitle(
      title,
    );
    return commmunities;
  }

  Future<Community?> updateCommunity(Community community) async {
    if (state.isLoadingUsersCommunities) return null;

    // mark as loading
    state = state.copyWith(isUpdatingUsersCommunities: true);

    // perform the API call
    final updated = await _communityRepository.updateCommunity(community);

    if (updated != null) {
      // build a new list, swapping in the updated community
      final updatedList =
          state.usersCommunities
              .map((c) => c.id == updated.id ? updated : c)
              .toList();

      // emit the new list + clear loading
      state = state.copyWith(
        isUpdatingUsersCommunities: false,
        usersCommunities: updatedList,
      );
    } else {
      // if update failed / returned null, just clear loading flag
      state = state.copyWith(isUpdatingUsersCommunities: false);
    }

    return updated;
  }

  Future<Community?> updateCommunityLocally(Community community) async {
    if (state.isLoadingUsersCommunities) return null;

    // mark as loading
    state = state.copyWith(isUpdatingUsersCommunities: true);

    // build a new list, swapping in the updated community
    final updatedList =
        state.usersCommunities
            .map((c) => c.id == community.id ? community : c)
            .toList();

    // emit the new list + clear loading
    state = state.copyWith(
      isUpdatingUsersCommunities: false,
      usersCommunities: updatedList,
    );
  
    return community;
  }

  Future<Community?> createCommunity(Community community) async {
    if (state.isLoadingUsersCommunities) return null;

    state = state.copyWith(isUpdatingUsersCommunities: true);

    final communityTitleAlreadyExists = await _communityRepository
        .getCommunityByTitle(community.title);
    if (communityTitleAlreadyExists != null) {
      throw CommunityAlreadyExistsException();
    }

    final created = await _communityRepository.createCommunity(community);

    if (created != null) {
      final updatedList =
          state.usersCommunities
              .map((c) => c.id == created.id ? created : c)
              .toList();

      state = state.copyWith(
        isUpdatingUsersCommunities: false,
        usersCommunities: updatedList,
      );
    } else {
      state = state.copyWith(isUpdatingUsersCommunities: false);
    }

    return created;
  }

  Future<bool> addPost(String commId, String postId) async {
    final result = await _communityRepository.addPost(commId, postId);
    return result;
  }

  Future<bool> removePost(String commId, String postId) async {
    final result = await _communityRepository.removePost(commId, postId);
    return result;
  }

  Future<bool> addSub(String commId, String userId) async {
    final result = await _communityRepository.addSub(commId, userId);
    return result;
  }

  Future<bool> removeSub(String commId, String userId) async {
    final result = await _communityRepository.removeSub(commId, userId);
    return result;
  }
}

class LoadCommunitiesState {
  final List<Community> usersCommunities;
  final bool isLoadingUsersCommunities;
  final bool isUpdatingUsersCommunities;

  LoadCommunitiesState({
    this.usersCommunities = const [],
    this.isLoadingUsersCommunities = false,
    this.isUpdatingUsersCommunities = false,
  });

  @override
  bool operator ==(covariant LoadCommunitiesState other) {
    if (identical(this, other)) return true;

    return listEquals(other.usersCommunities, usersCommunities) &&
        other.isLoadingUsersCommunities == isLoadingUsersCommunities &&
        other.isUpdatingUsersCommunities == isUpdatingUsersCommunities;
  }

  @override
  int get hashCode =>
      usersCommunities.hashCode ^
      isLoadingUsersCommunities.hashCode ^
      isUpdatingUsersCommunities.hashCode;

  LoadCommunitiesState copyWith({
    List<Community>? usersCommunities,
    bool? isLoadingUsersCommunities,
    bool? isUpdatingUsersCommunities,
  }) {
    return LoadCommunitiesState(
      usersCommunities: usersCommunities ?? this.usersCommunities,
      isLoadingUsersCommunities:
          isLoadingUsersCommunities ?? this.isLoadingUsersCommunities,
      isUpdatingUsersCommunities:
          isUpdatingUsersCommunities ?? this.isUpdatingUsersCommunities,
    );
  }
}
