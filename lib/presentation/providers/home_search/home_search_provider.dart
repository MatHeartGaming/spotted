import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';

/// 1A) Search Users by a partial username (or however your repo does it)
///    Replace `.getUsersByUsernameContains(query)` with your own repo method.
final searchUsersProvider = FutureProvider.family.autoDispose<List<UserModel>, String>((
  ref,
  query,
) async {
  if (query.trim().isEmpty) {
    return <UserModel>[];
  }
  final usersRepo = ref.watch(usersRepositoryProvider);
  // Assume your UsersRepository has a method like:
  //    Future<List<User>> getUsersByUsernameContains(String query);
  // If you only have `getUserByUsername(String)`, you can call that and
  // wrap in a one‐element list (or return empty if null). For demo:
  final matches = await usersRepo.getUsersByUsername(query);
  return matches ?? <UserModel>[];
});

/// 1B) Search Posts by a partial title/content (adapt to your repo)
final searchPostsProvider = FutureProvider.family.autoDispose<List<Post>, String>((
  ref,
  query,
) async {
  if (query.trim().isEmpty) {
    return <Post>[];
  }
  final postsRepo = ref.watch(postsRepositoryProvider);
  // Assume you have a method like:
  //    Future<List<Post>> getPostsByTitleOrContent(String query)
  final matches =
      await postsRepo.getAllPostsByTitle(query) +
      await postsRepo.getAllPostsByContent(query);
  return matches;
});

/// 1C) Search Communities by a partial title (adapt to your repo)
final searchCommunitiesProvider =
    FutureProvider.family.autoDispose<List<Community>, String>((ref, query) async {
      if (query.trim().isEmpty) {
        return <Community>[];
      }
      final commRepo = ref.watch(communityRepositoryProvider);
      // Assume you have:
      //    Future<List<Community>> getCommunitiesByTitleContains(String query)
      final matches = await commRepo.getCommunitiesByTitle(query);
      return matches;
    });
