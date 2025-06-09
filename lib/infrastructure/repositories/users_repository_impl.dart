import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/user.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';

class UsersRepositoryImplementation implements UsersRepository {
  final UsersDatasource _db;

  UsersRepositoryImplementation([UsersDatasource? db])
    : _db = db ?? UsersDatasourceMockImpl();

  @override
  Future<List<User>> getAllUsers() {
    return _db.getAllUsers();
  }

  @override
  Future<User?> getUserByEmail(String email) {
    return _db.getUserByEmail(email);
  }

  @override
  Future<User?> getUserById(String id) {
    return _db.getUserById(id);
  }

  @override
  Future<User?> getUserByUsername(String username) {
    return _db.getUserByUsername(username);
  }

  @override
  Future<User?> createUser(User user, String uid) {
    return _db.createUser(user, uid);
  }

  @override
  Future<void> updateUser(User user) {
    return _db.updateUser(user);
  }

  @override
  Future<List<User>?> getUsersById(List<String> listRef) {
    return _db.getUsersById(listRef);
  }

  @override
  Future<bool> deleteUserById(User user) {
    return _db.deleteUserById(user);
  }

  @override
  Future<List<User>?> getUsersByUsername(String username) {
    return _db.getUsersByUsername(username);
  }

  @override
  Future<bool> addSub(String userId, String commId) {
    return _db.addSub(userId, commId);
  }

  @override
  Future<bool> removeSub(String userId, String commId) {
    return _db.removeSub(userId, commId);
  }
}
