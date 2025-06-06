import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';
import 'package:spotted/infrastructure/repositories/repositories.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  return PostsRepositoryImplementation(PostsDatasourceFirebaseImpl());
});
