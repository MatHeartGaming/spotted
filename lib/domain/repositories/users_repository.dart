import 'package:spotted/domain/models/models.dart';

abstract class UsersRepository {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<List<User>?> getUsersById(List<String> listRef);
  Future<User?> getUserByUsername(String username);
  Future<User?> getUserByEmail(String email);
  Future<List<User>?> getUsersByUsername(String username);
  Future<User?> createUser(User user, String uid);
  Future<void> updateUser(User user);
  Future<bool> deleteUserById(User user);
}
