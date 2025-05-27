// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';

class LoadCommunitiesNotifier extends StateNotifier<LoadCommunitiesState> {
  final CommunityRepository _communityRepository;
  final User _signedInUser;

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

  Future<Community?> createCommunity(Community community) async {
    // (optional) avoid concurrent updates
    if (state.isLoadingUsersCommunities) return null;

    state = state.copyWith(isUpdatingUsersCommunities: true);

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
