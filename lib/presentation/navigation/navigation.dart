import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spotted/config/config.dart';

void pushToChatsScreen(BuildContext context) {
  if (!context.mounted) return;
  context.push(chatsPath);
}
