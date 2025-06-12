import 'package:spotted/domain/datasources/user_notification_datasource.dart';
import 'package:spotted/domain/models/user_notification.dart';
import 'package:spotted/domain/repositories/user_notification_repository.dart';
import 'package:spotted/infrastructure/datasources/user_notification_datasource_firebase_impl.dart';

class UserNotificationRepositoryImpl implements UserNotificationRepository {
  final UserNotificationDatasource _db;

  UserNotificationRepositoryImpl([UserNotificationDatasource? db])
    : _db = db ?? UserNotificationDatasourceFirebaseImpl();

  @override
  Future<UserNotification?> createUserNotification(
    UserNotification newNotification,
  ) {
    return _db.createUserNotification(newNotification);
  }

  @override
  Future<UserNotification?> getNotificationById(String id) {
    return _db.getNotificationById(id);
  }

  @override
  Future<List<UserNotification>> getNotificationsByReceiverId(String id) {
    return _db.getNotificationsByReceiverId(id);
  }

  @override
  Future<List<UserNotification>> getNotificationsBySenderId(String id) {
    return _db.getNotificationsBySenderId(id);
  }

  @override
  Future<UserNotification?> updateUserNotification(
    UserNotification updatedNotification,
  ) {
    return _db.updateUserNotification(updatedNotification);
  }

  @override
  Future<int> getUnreadCountByReceiverId(String receiverId) {
    return _db.getUnreadCountByReceiverId(receiverId);
  }
}
