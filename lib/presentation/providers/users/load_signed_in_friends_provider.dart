// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final loadSignedInFriendsProvider = StateNotifierProvider<
  LoadSignedInFriendsNotifier,
  LoadSignedInFriendsUserState
>((ref) {
  final usersRepo = ref.watch(usersRepositoryProvider);
  final signedInUser = ref.watch(signedInUserProvider) ?? UserModel.empty();
  final userNotifier = LoadSignedInFriendsNotifier(usersRepo, signedInUser);
  return userNotifier;
});

class LoadSignedInFriendsNotifier
    extends StateNotifier<LoadSignedInFriendsUserState> {
  final UsersRepository _usersRepository;
  final UserModel _signedInUser;

  LoadSignedInFriendsNotifier(this._usersRepository, this._signedInUser)
    : super(
        LoadSignedInFriendsUserState(
          signedInUserFriendsList: _signedInUser.friends,
        ),
      );

  Future<List<UserModel>?> loadUserSignedInUserFriends() async {
    if (state.isLoadingSignedInUserFriendsList) {
      return state.signedInUserFriendsList;
    }
    state = state.copyWith(isLoadingSignedInUserFriendsList: true);
    final friends = await _usersRepository.getUsersById(
      _signedInUser.friendsRefs,
    );
    state = state.copyWith(
      isLoadingSignedInUserFriendsList: false,
      signedInUserFriendsList: friends,
    );
    logger.d('Friends State: ${state.signedInUserFriendsList}');
    return friends;
  }

  Future<(UserModel?, bool)> addOrRemoveSignedInUserFriend(String friendRef) async {
    List<String> newFriendList = List.from(_signedInUser.friendsRefs);
    final indexFriend = newFriendList.indexOf(friendRef);
    bool isAdd = true;
    if (indexFriend == -1) {
      newFriendList.add(friendRef);
    } else {
      isAdd = false;
      newFriendList.removeAt(indexFriend);
    }
    final friendsToUser = await _usersRepository.getUsersById(newFriendList);
    final updatedUser = await updateUser(
      _signedInUser.copyWith(
        friendsRefs: newFriendList,
        friends: friendsToUser ?? _signedInUser.friends,
      ),
    );

    // Update signed in user firends state
    state = state.copyWith(signedInUserFriendsList: friendsToUser);

    return (updatedUser, isAdd);
  }

  Future<UserModel?> updateUser(UserModel user) async {
    await _usersRepository.updateUser(user);
    return user;
  }

  Future<List<UserModel>> getUsersById(List<String> userRefs) async {
    final users = await _usersRepository.getUsersById(userRefs);
    return users ?? [];
  }
}

class LoadSignedInFriendsUserState {
  final List<UserModel> signedInUserFriendsList;
  final bool isLoadingSignedInUserFriendsList;

  LoadSignedInFriendsUserState({
    this.signedInUserFriendsList = const [],
    this.isLoadingSignedInUserFriendsList = false,
  });

  @override
  bool operator ==(covariant LoadSignedInFriendsUserState other) {
    if (identical(this, other)) return true;

    return listEquals(other.signedInUserFriendsList, signedInUserFriendsList) &&
        other.isLoadingSignedInUserFriendsList ==
            isLoadingSignedInUserFriendsList;
  }

  @override
  int get hashCode =>
      signedInUserFriendsList.hashCode ^
      isLoadingSignedInUserFriendsList.hashCode;

  LoadSignedInFriendsUserState copyWith({
    List<UserModel>? signedInUserFriendsList,
    bool? isLoadingSignedInUserFriendsList,
  }) {
    return LoadSignedInFriendsUserState(
      signedInUserFriendsList:
          signedInUserFriendsList ?? this.signedInUserFriendsList,
      isLoadingSignedInUserFriendsList:
          isLoadingSignedInUserFriendsList ??
          this.isLoadingSignedInUserFriendsList,
    );
  }
}
