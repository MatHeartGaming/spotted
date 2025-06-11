import 'package:spotted/domain/models/models.dart';

abstract class UserNotificationRepository {
  Future<UserNotification?> createUserNotification(
    UserNotification newNotification,
  );
  Future<UserNotification?> getNotificationById(String id);
}
