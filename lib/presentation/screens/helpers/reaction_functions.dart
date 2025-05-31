import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';

Future<void> updatePostActionWithReaction(
  Post post,
  String reaction,
  WidgetRef ref,
) async {
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

  final newUserValue = await usersRepo.updateUser(updatedUser);
  if (newUserValue != null) {
    // Now updating `signedInUserProvider` will NOT reset LoadPostsNotifier’s state.
    ref.read(signedInUserProvider.notifier).update((_) => newUserValue);
  }
}

/// Returns a new map where:
///  • If [reaction] == '👍', then tapping always “toggles off” any existing reaction, 
///    or adds 👍 if there was none.  
///  • Otherwise (reaction is some other emoji), we remove if it matches exactly,
///    or overwrite if it’s different.
Map<String, String> _toggleReaction(
  Map<String, String> map,
  String userId,
  String reaction,
) {
  // Make a local copy so we don’t mutate the original:
  final copy = Map<String, String>.from(map);

  // 1) If the user tapped “👍”, treat it specially:
  if (reaction == '👍') {
    // If they already have any reaction, remove it (including 👍 itself).
    if (copy.containsKey(userId)) {
      copy.remove(userId);
    }
    // Otherwise, add 👍.
    else {
      copy[userId] = '👍';
    }
    return copy;
  }

  // 2) If it’s not “👍”, i.e. some other emoji:
  final existing = copy[userId];
  if (existing == reaction) {
    // Tapped the same emoji again → remove it.
    copy.remove(userId);
  } else {
    // Tapped a different emoji → overwrite.
    copy[userId] = reaction;
  }
  return copy;
}

