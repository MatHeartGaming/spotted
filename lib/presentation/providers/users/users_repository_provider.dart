
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/repositories/users_repository_impl.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImplementation();
});