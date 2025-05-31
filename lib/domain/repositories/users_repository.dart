import 'package:spotted/domain/models/models.dart';

abstract class UsersRepository {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<List<User>?> getUsersById(List<String> listRef);
  Future<User?> getUserByUsername(String username);
  Future<User?> getUserByEmail(String email);
  Future<User?> createUser(User user);
  Future<User?> updateUser(User user);
  Future<List<User>?> deleteUserById(String id);
}
