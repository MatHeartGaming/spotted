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
  Future<User?> createUser(User user) {
    return _db.createUser(user);
  }

  @override
  Future<User?> updateUser(User user) {
    return _db.updateUser(user);
  }

  @override
  Future<List<User>?> getUsersById(List<String> listRef) {
    return _db.getUsersById(listRef);
  }

  @override
  Future<List<User>?> deleteUserById(String id) {
    return _db.deleteUserById(id);
  }
}
