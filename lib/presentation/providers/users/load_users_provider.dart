// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/providers.dart';

final userScreenCurrentUserProvider = StateProvider.autoDispose<User>((ref) {
  return User.empty();
});

final loadUserProvider = StateNotifierProvider.autoDispose<LoadUserNotifier, LoadUserState>(
  (ref) {
    final usersRepo = ref.watch(usersRepositoryProvider);
    final userNotifier = LoadUserNotifier(usersRepo);
    return userNotifier;
  },
);

class LoadUserNotifier extends StateNotifier<LoadUserState> {
  final UsersRepository _usersRepository;

  LoadUserNotifier(this._usersRepository)
    : super(LoadUserState(user: User.empty()));

  Future<User?> loadUserById(String userId) async {
    if (state.isLoadingUser) return state.user;
    state = state.copyWith(isLoadingUser: true);
    final userById = await _usersRepository.getUserById(userId);
    state = state.copyWith(isLoadingUser: false, user: userById);
    return userById;
  }

  Future<User?> loadUserByUsername(String username) async {
    if (state.isLoadingUser) return state.user;
    state = state.copyWith(isLoadingUser: true);
    final userById = await _usersRepository.getUserByUsername(username);
    state = state.copyWith(isLoadingUser: false, user: userById);
    return userById;
  }
}

class LoadUserState {
  final User user;
  final bool isLoadingUser;

  LoadUserState({required this.user, this.isLoadingUser = false});

  @override
  bool operator ==(covariant LoadUserState other) {
    if (identical(this, other)) return true;

    return other.user == user && other.isLoadingUser == isLoadingUser;
  }

  @override
  int get hashCode => user.hashCode ^ isLoadingUser.hashCode;

  LoadUserState copyWith({User? user, bool? isLoadingUser}) {
    return LoadUserState(
      user: user ?? this.user,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
    );
  }
}
