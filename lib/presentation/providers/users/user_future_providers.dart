import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/users/users_repository_provider.dart';

final userFutureByIdProvider = FutureProvider.family<UserModel?, String>((ref, id) async {
  final userRepo = ref.watch(usersRepositoryProvider);
  return await userRepo.getUserById(id);
});

final usersFutureByIdProvider = FutureProvider.family<List<UserModel>?, List<String>>((ref, idList) async {
  final userRepo = ref.watch(usersRepositoryProvider);
  return await userRepo.getUsersById(idList);
});

final userFutureByUsernameProvider = FutureProvider.family<UserModel?, String>((ref, username) async {
  final userRepo = ref.watch(usersRepositoryProvider);
  return await userRepo.getUserByUsername(username);
});

final userFutureByEmailProvider = FutureProvider.family<UserModel?, String>((ref, email) async {
  final userRepo = ref.watch(usersRepositoryProvider);
  return await userRepo.getUserByEmail(email);
});