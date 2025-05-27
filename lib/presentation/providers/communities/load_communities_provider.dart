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
    if (state.isLaodingUsersCommunities) return state.usersCommunities;
    state = state.copyWith(isLaodingUsersCommunities: true);

    final usersCommmunity = await _communityRepository
        .getCommunitiesUsingUsersCommunityIdList(_signedInUser.communitiesSubs);

    state = state.copyWith(
      isLaodingUsersCommunities: false,
      usersCommunities: usersCommmunity,
    );

    return usersCommmunity;
  }
}

class LoadCommunitiesState {
  final List<Community> usersCommunities;
  final bool isLaodingUsersCommunities;

  LoadCommunitiesState({
    this.usersCommunities = const [],
    this.isLaodingUsersCommunities = false,
  });

  @override
  bool operator ==(covariant LoadCommunitiesState other) {
    if (identical(this, other)) return true;

    return listEquals(other.usersCommunities, usersCommunities) &&
        other.isLaodingUsersCommunities == isLaodingUsersCommunities;
  }

  @override
  int get hashCode =>
      usersCommunities.hashCode ^ isLaodingUsersCommunities.hashCode;

  LoadCommunitiesState copyWith({
    List<Community>? usersCommunities,
    bool? isLaodingUsersCommunities,
  }) {
    return LoadCommunitiesState(
      usersCommunities: usersCommunities ?? this.usersCommunities,
      isLaodingUsersCommunities:
          isLaodingUsersCommunities ?? this.isLaodingUsersCommunities,
    );
  }
}
