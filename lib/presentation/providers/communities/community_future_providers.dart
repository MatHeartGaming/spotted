import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart' show Community;
import 'package:spotted/presentation/providers/communities/community_repository_provider.dart';

final communityByIdFutureProvider = FutureProvider.family
    .autoDispose<Community?, String?>((ref, id) async {
      if (id == null) return null;
      final communityRepo = ref.watch(communityRepositoryProvider);
      return await communityRepo.getCommunityById(id);
    });
