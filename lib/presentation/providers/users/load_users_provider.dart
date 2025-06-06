// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';
import 'package:spotted/presentation/providers/providers.dart';

final userScreenCurrentUserProvider = StateProvider.autoDispose<User>((ref) {
  return User.empty();
});

final loadUserProvider =
    StateNotifierProvider.autoDispose<LoadUserNotifier, LoadUserState>((ref) {
      final usersRepo = ref.watch(usersRepositoryProvider);
      final userNotifier = LoadUserNotifier(usersRepo);
      return userNotifier;
    });

class LoadUserNotifier extends StateNotifier<LoadUserState> {
  final UsersRepository _usersRepository;

  LoadUserNotifier(this._usersRepository)
    : super(LoadUserState(userForProfileScreen: User.empty()));

  Future<User?> loadUserById(String userId) async {
    if (state.isLoadingUser) return state.userForProfileScreen;
    state = state.copyWith(isLoadingUser: true);
    final userById = await _usersRepository.getUserById(userId);
    state = state.copyWith(
      isLoadingUser: false,
      userForProfileScreen: userById,
    );
    return userById;
  }

  Future<User?> loadUserByUsername(String username) async {
    if (state.isLoadingUser) return state.userForProfileScreen;
    state = state.copyWith(isLoadingUser: true);
    final userById = await _usersRepository.getUserByUsername(username);
    state = state.copyWith(
      isLoadingUser: false,
      userForProfileScreen: userById,
    );
    return userById;
  }

  Future<void> updateUser(User user) async {
    await _usersRepository.updateUser(user);
  }

  Future<List<User>> getUsersById(List<String> userRefs) async {
    final users = await _usersRepository.getUsersById(userRefs);
    return users ?? [];
  }

  Future<User?> createUser({required User user, required String authId}) async {
    try {
      final newUser = await _usersRepository.createUser(user, authId);
      return newUser;
    } on EmailAlreadyExistsException {
      // rethrow so UI knows “EmailAlreadyExistsException”
      rethrow;
    } on UsernameAlreadyExistsException {
      rethrow;
    } on GenericUserCreationException catch (genericError) {
      // If you want, you can package any generic message inside a single
      // “generic” exception. Or you might prefer to return null and let the UI decide.
      logger.e('Generic error in User creation: $genericError');
      rethrow;
    } catch (e) {
      // Some unexpected exception – wrap or rethrow.
      rethrow;
    }
  }
}

class LoadUserState {
  final User userForProfileScreen;
  final bool isLoadingUser;

  LoadUserState({
    required this.userForProfileScreen,
    this.isLoadingUser = false,
  });

  @override
  bool operator ==(covariant LoadUserState other) {
    if (identical(this, other)) return true;

    return other.userForProfileScreen == userForProfileScreen &&
        other.isLoadingUser == isLoadingUser;
  }

  @override
  int get hashCode => userForProfileScreen.hashCode ^ isLoadingUser.hashCode;

  LoadUserState copyWith({User? userForProfileScreen, bool? isLoadingUser}) {
    return LoadUserState(
      userForProfileScreen: userForProfileScreen ?? this.userForProfileScreen,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
    );
  }
}
