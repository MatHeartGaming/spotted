import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class UsersDatasourceMockImpl implements UsersDatasource {
  @override
  Future<User?> createUser(User user) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockUsers.add(user);
      return user;
    });
  }

  @override
  Future<User?> updateUser(User user) async {
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
  Future<List<User>> getAllUsers() async {
    var rng = Random();
    int randomTime = rng.nextInt(500);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockUsers,
    );
  }

  @override
  Future<List<User>?> getUsersById(List<String> listRef) async {
    List<Future<User?>> futures = [];

    for (String r in listRef) {
      Future<User?> future = getUserById(r);
      futures.add(future);
    }
    List<User?> list = await Future.wait(futures);
    List<User> nonNullUsers = [];
    for (User? c in list) {
      if (c != null) {
        nonNullUsers.add(c);
      }
    }
    return nonNullUsers;
  }

  @override
  Future<User?> getUserById(String id) async {
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
  Future<User?> getUserByUsername(String username) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockUsers.where((u) => u.username == username).toList().firstOrNull,
    );
  }

  @override
  Future<List<User>?> getUsersByUsername(String username) async {
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
  Future<User?> getUserByEmail(String email) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockUsers.where((u) => u.email == email).toList().firstOrNull,
    );
  }

  @override
  Future<List<User>?> deleteUserById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockUsers.removeWhere((u) => u.id == id);
      return mockUsers;
    });
  }
}
