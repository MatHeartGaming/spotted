import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class UsersDatasourceMockImpl implements UsersDatasource {
  @override
  Future<UserModel?> createUser(UserModel user, String uid) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockUsers.add(user);
      return user;
    });
  }

  @override
  Future<UserModel?> updateUser(UserModel user) async {
    final rng = Random();
    final randomTime = rng.nextInt(300);

    return await Future.delayed(Duration(milliseconds: randomTime), () {
      // find index of existing user
      final idx = mockUsers.indexWhere((u) => u.id == user.id);
      if (idx != -1) {
        // replace the old user
        mockUsers[idx] = user;
        return user;
      }
      // not found: nothing to update
      return null;
    });
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    var rng = Random();
    int randomTime = rng.nextInt(500);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockUsers,
    );
  }

  @override
  Future<List<UserModel>?> getUsersById(List<String> listRef) async {
    List<Future<UserModel?>> futures = [];

    for (String r in listRef) {
      Future<UserModel?> future = getUserById(r);
      futures.add(future);
    }
    List<UserModel?> list = await Future.wait(futures);
    List<UserModel> nonNullUsers = [];
    for (UserModel? c in list) {
      if (c != null) {
        nonNullUsers.add(c);
      }
    }
    return nonNullUsers;
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      final user =
          mockUsers
              .where((u) {
                return u.id == id;
              })
              .toList()
              .firstOrNull;
      return user;
    });
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockUsers.where((u) => u.username == username).toList().firstOrNull,
    );
  }

  @override
  Future<List<UserModel>?> getUsersByUsername(String username) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockUsers
              .where(
                (u) => u.username.toLowerCase().trim().contains(
                  username.trim().toLowerCase(),
                ),
              )
              .toList(),
    );
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockUsers.where((u) => u.email == email).toList().firstOrNull,
    );
  }

  @override
  Future<bool> deleteUserById(UserModel user) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockUsers.removeWhere((u) => u.id == user.id);
      return true;
    });
  }
  
  @override
  Future<bool> addSub(String userId, String commId) {
    // TODO: implement addSub
    throw UnimplementedError();
  }
  
  @override
  Future<bool> removeSub(String userId, String commId) {
    // TODO: implement removeSub
    throw UnimplementedError();
  }
  
  @override
  Future<bool> addPost(String userId, String postId) {
    // TODO: implement addPost
    throw UnimplementedError();
  }
  
  @override
  Future<bool> removePost(String userId, String postId) {
    // TODO: implement removePost
    throw UnimplementedError();
  }
}
