import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/community.dart';
import 'package:spotted/domain/models/user.dart';

void pushToChatsScreen(BuildContext context) {
  if (!context.mounted) return;
  context.push(chatsPath);
}

void goToHomeScreenUsingContext(BuildContext context) {
  if (!context.mounted) return;
  context.go(basePath);
}

void pushToCreatePostScreen(BuildContext context) {
  if (!context.mounted) return;
  context.push(createPostPath);
}

void popContext(BuildContext context) {
  if (!context.mounted) return;
  context.pop();
}

void pushToCreateCommunityScreen(BuildContext context, {Community? community}) {
  if (!context.mounted) return;
  if (community == null) {
    context.push(createCommunityPath);
    return;
  }
  Map<String, Community> extras = {'community': community};
  context.push(createCommunityPath, extra: extras);
}

void pushToProfileScreen(
  BuildContext context, {
  User? user,
  String userId = 'no-id',
  String? username,
}) {
  if (!context.mounted) return;
  Map<String, dynamic> mapExtras = {'user': user, 'username': username};
  context.push('$profilePath/$userId', extra: mapExtras);
}

void pushToCommunityScreen(
  BuildContext context, {
  Community? community,
  String communityId = 'no-id',
  String? title,
}) {
  if (!context.mounted) return;
  Map<String, dynamic> mapExtras = {'community': community, 'title': title};
  context.push('$communityPath/$communityId', extra: mapExtras);
}
