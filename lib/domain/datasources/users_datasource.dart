import 'package:spotted/domain/models/models.dart';

abstract class UsersDatasource {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<User?> getUserByUsername(String username);
  Future<User?> getUserByEmail(String email);
}
