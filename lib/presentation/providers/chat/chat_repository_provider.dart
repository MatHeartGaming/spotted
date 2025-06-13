
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/chat/chat_repository.dart';
import 'package:spotted/infrastructure/repositories/repositories.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});