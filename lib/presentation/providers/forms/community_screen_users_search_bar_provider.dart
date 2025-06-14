import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';

final ownerUsersSearchBarProvider = StateProvider.autoDispose<List<UserModel>>((
  ref,
) {
  final text = ref.watch(communityUsersSearchBarTextProvider);
  final signedInUser = ref.watch(signedInUserProvider);
  final searchText = text.toLowerCase().trim();
  final friends = ref
      .read(loadSignedInFriendsProvider)
      .signedInUserFriendsList
      .where((f) => f != signedInUser);
  return friends
      .where((f) => f.username.toLowerCase().contains(searchText))
      .toList();
});

final communityUsersSearchBarTextProvider = StateProvider.autoDispose<String>((
  ref,
) {
  return '';
});
