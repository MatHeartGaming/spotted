
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/user_notification_repository.dart';
import 'package:spotted/infrastructure/repositories/repositories.dart';

final userNotificationRepositoryProvider = Provider<UserNotificationRepository>((ref) {
  return UserNotificationRepositoryImpl();
});