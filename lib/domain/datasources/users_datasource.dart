import 'package:spotted/domain/models/models.dart';

abstract class UsersDatasource {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(String id);
  Future<List<UserModel>?> getUsersById(List<String> listRef);
  Future<UserModel?> getUserByUsername(String username);
  Future<List<UserModel>?> getUsersByUsername(String username);
  Future<UserModel?> getUserByEmail(String email);
  Future<UserModel?> createUser(UserModel user, String uid);
  Future<void> updateUser(UserModel user);
  Future<bool> deleteUserById(UserModel user);
  Future<bool> addSub(String userId, String commId);
  Future<bool> removeSub(String userId, String commId);
  Future<bool> addPost(String userId, String postId);
  Future<bool> removePost(String userId, String postId);
}
