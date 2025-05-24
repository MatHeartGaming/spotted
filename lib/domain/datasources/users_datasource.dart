import 'package:spotted/domain/models/models.dart';

abstract class UsersDatasource {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<User?> getUserByUsername(String username);
  Future<List<User>?> getUsersByUsername(String username);
  Future<User?> getUserByEmail(String email);
  Future<User?> createUser(User user);
  Future<User?> updateUser(User user);
}
