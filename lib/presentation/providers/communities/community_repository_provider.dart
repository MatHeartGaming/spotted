
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/repositories/community_repository_impl.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImplementation();
});