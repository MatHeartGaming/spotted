import 'package:spotted/domain/models/models.dart';

abstract class UserNotificationDatasource {
  Future<UserNotification?> createUserNotification(
    UserNotification newNotification,
  );
  Future<UserNotification?> getNotificationById(String id);
}
