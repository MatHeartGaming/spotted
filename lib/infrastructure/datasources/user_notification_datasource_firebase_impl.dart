import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/constants/db_constants.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/models/user_notification.dart';

class UserNotificationDatasourceFirebaseImpl
    implements UserNotificationDatasource {
  final CollectionReference<UserNotification> _userNotificationRef =
      FirebaseFirestore.instance
          .collection(FirestoreDbCollections.userNotifications)
          .withConverter<UserNotification>(
            fromFirestore: UserNotification.fromFirestore,
            toFirestore: (UserNotification un, _) => un.toMap(),
          );

  @override
  Future<UserNotification?> createUserNotification(
    UserNotification newNotification,
  ) async {
    final docRef = await _userNotificationRef.add(newNotification);
    await docRef.update({'id': docRef.id});
    return newNotification.copyWith(id: docRef.id);
  }

  @override
  Future<UserNotification?> getNotificationById(String id) async {
    final doc = await _userNotificationRef.doc(id).get();
    return doc.exists ? doc.data() : null;
  }
}
