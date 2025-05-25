import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/user.dart';

void pushToChatsScreen(BuildContext context) {
  if (!context.mounted) return;
  context.push(chatsPath);
}

void goToHomeScreenUsingContext(BuildContext context) {
  if (!context.mounted) return;
  context.go(basePath);
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
