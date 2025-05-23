import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';

class UsersDatasourceMockImpl implements UsersDatasource {
  
  @override
  Future<List<User>> getAllUsers() async {
    return [];
  }

  @override
  Future<User?> getUserById(String id) async {
    return null;
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    return null;
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return null;
  }
}
