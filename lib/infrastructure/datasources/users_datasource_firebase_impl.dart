import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/user.dart';

class UsersDatasourceFirebaseImpl implements UsersDatasource {
  @override
  Future<List<User>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserByEmail(String email) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserByUsername(String username) {
    // TODO: implement getUserByUsername
    throw UnimplementedError();
  }

  @override
  Future<List<User>?> getUsersByUsername(String username) async {
    return [];
  }
  
  @override
  Future<User?> createUser(User user) {
    // TODO: implement createUser
    throw UnimplementedError();
  }
  
  @override
  Future<User?> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
