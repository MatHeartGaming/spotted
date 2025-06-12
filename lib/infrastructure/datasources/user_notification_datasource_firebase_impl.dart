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

    @override
  Future<List<UserNotification>> getNotificationsByReceiverId(String id) async {
    final querySnapshot = await _userNotificationRef
        .where('receiver_id', isEqualTo: id)
        .orderBy('date_created', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

  @override
  Future<List<UserNotification>> getNotificationsBySenderId(String id) async {
    final querySnapshot = await _userNotificationRef
        .where('sender_id', isEqualTo: id)
        .orderBy('date_created', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

    @override
  Future<UserNotification?> updateUserNotification(
    UserNotification updatedNotification,
  ) async {
    // Grab a reference to the existing document
    final docRef = _userNotificationRef.doc(updatedNotification.id);

    // Update all fields in Firestore
    await docRef.update(updatedNotification.toMap());

    // Re‐read the document so you get the latest data (including any server‐side transforms)
    final refreshed = await docRef.get();
    return refreshed.exists ? refreshed.data() : null;
  }

  @override
  Future<int> getUnreadCountByReceiverId(String receiverId) async {
    final aggregate = await _userNotificationRef
        .where('receiver_id', isEqualTo: receiverId)
        .where('clicked', isEqualTo: false)
        .count()
        .get();
    return aggregate.count ?? 0;
  }

}
