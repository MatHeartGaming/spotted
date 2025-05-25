import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';

void updatePostActionWithReaction(Post post, String reaction, WidgetRef ref) async {
    final notifier = ref.read(loadPostsProvider.notifier);
    final user = ref.read(signedInUserProvider);
    if (user == null) return;

    // 1) Toggle reaction on the Post
    final updatedPost = post.copyWith(
      reactions: _toggleReaction(post.reactions, user.id, reaction),
    );

    // 2) Persist it
    final resultPost = await notifier.updatePost(updatedPost);
    if (resultPost == null) return;

    // 3) Toggle reaction on the User
    final usersRepo = ref.read(usersRepositoryProvider);
    final updatedUser = user.copyWith(
      reactions: _toggleReaction(user.reactions, resultPost.id, reaction),
    );
    await usersRepo.updateUser(updatedUser);
  }

  /// Returns a new map where [map][id] == [reaction] is removed if equal,
  /// or added/overwritten otherwise.
  Map<String, String> _toggleReaction(
    Map<String, String> map,
    String id,
    String reaction,
  ) {
    final copy = Map<String, String>.from(map);
    if (copy[id] == reaction) {
      copy.remove(id);
    } else {
      copy[id] = reaction;
    }
    return copy;
  }