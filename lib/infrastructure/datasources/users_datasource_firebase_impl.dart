import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/user.dart';
import 'package:spotted/infrastructure/datasources/exceptions/user_exceptions.dart';

class UsersDatasourceFirebaseImpl implements UsersDatasource {
  final _db = FirebaseFirestore.instance;

  final CollectionReference<User> _usersRef = FirebaseFirestore
      .instance
      .collection(FirestoreDbCollections.communities)
      .withConverter<User>(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toMap(),
      );

  @override
  Future<List<User>> getAllUsers() async {
    List<User> result = [];
    return await _db
        .collection(FirestoreDbCollections.users)
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            final user = User.fromFirestore(docSnapshot, null);
            result.add(user.copyWith(id: docSnapshot.id));
          }
          return result;
        })
        .onError((error, stackTrace) {
          logger.e("$error");
          throw Exception(stackTrace);
        });
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return await _db
        .collection(FirestoreDbCollections.users)
        .where('email', isEqualTo: email)
        .limit(1)
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (user, options) => user.toMap(),
        )
        .get()
        .then((value) {
          if (value.docs.isEmpty) {
            final messageError = "User with email $email not found!";
            logger.e(messageError);
            return null;
          }
          final user = value.docs.first.data().copyWith(
            id: value.docs.first.id,
          );
          return user;
        })
        .onError((error, stackTrace) {
          logger.e(error);
          throw Exception("$error");
        });
  }

  @override
  Future<User?> getUserById(String id) async {
    return await _db
        .collection(FirestoreDbCollections.users)
        .doc(id)
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (user, options) => user.toMap(),
        )
        .get()
        .then((value) {
          if (!value.exists) {
            final messageError = "User with id $id not found!";
            logger.e(messageError);
            return null;
          }
          final user = value.data()?.copyWith(id: value.id);
          return user;
        })
        .onError((error, stackTrace) {
          logger.e(error);
          throw Exception("$error");
        });
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    return await _db
        .collection(FirestoreDbCollections.users)
        .where('username', isEqualTo: username)
        .limit(1)
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (user, options) => user.toMap(),
        )
        .get()
        .then((value) {
          if (value.docs.isEmpty) {
            final messageError = "User with username $username not found!";
            logger.e(messageError);
            return null;
          }
          final user = value.docs.first.data().copyWith(
            id: value.docs.first.id,
          );
          return user;
        })
        .onError((error, stackTrace) {
          logger.e(error);
          throw Exception("$error");
        });
  }

  @override
  Future<List<User>?> getUsersByUsername(String username) async {
    try {
      final querySnapshot =
          await _db
              .collection(FirestoreDbCollections.users)
              .where('username', isGreaterThanOrEqualTo: username)
              .where('username', isLessThan: '$username\uf8ff')
              .withConverter<User>(
                fromFirestore: User.fromFirestore,
                toFirestore: (User u, _) => u.toMap(),
              )
              .get();

      if (querySnapshot.docs.isEmpty) {
        // If you’d rather return null when no matches exist, change this to `return null;`
        return [];
      }

      final List<User> users =
          querySnapshot.docs
              .map((docSnap) => docSnap.data().copyWith(id: docSnap.id))
              .toList();

      return users;
    } catch (error, _) {
      logger.e("Error in getUsersByUsername: $error");
      throw Exception("Error fetching users by username: $error");
    }
  }

  @override
  Future<User?> createUser(User user, String uid) async {
    // Prepare the “lookup” document references:
    final emailDocRef = _db
        .collection('user_emails')
        .doc(user.email.toLowerCase()); // normalize email to lowercase

    final usernameDocRef = _db
        .collection('user_usernames')
        .doc(user.username.toLowerCase()); // normalize username

    // Prepare the “actual user” document reference:
    final userDocRef = _db.collection(FirestoreDbCollections.users).doc(uid);

    // Build the user data map once, so we can write it into Firestore:
    final userData =
        user.copyWith(dateCreated: DateTime.now(), friendsRefs: [uid]).toMap();

    try {
      // Run everything in one transaction so that “check & write” is atomic:
      final createdUser = await _db.runTransaction<User?>((transaction) async {
        // 1) Read the email‐lookup document.
        final emailSnapshot = await transaction.get(emailDocRef);
        if (emailSnapshot.exists) {
          // If the document already exists, that email is taken:
          throw EmailAlreadyExistsException(user.email);
        }

        // 2) Read the username‐lookup document.
        final usernameSnapshot = await transaction.get(usernameDocRef);
        if (usernameSnapshot.exists) {
          // If the document already exists, that username is taken:
          throw UsernameAlreadyExistsException(user.username);
        }

        // 3) Neither “lookup” doc exists → safe to create
        //    Write BOTH “lookup” docs and the real user doc atomically:
        transaction.set(
          emailDocRef,
          {'uid': uid}, // You could store more if you like, but uid is enough
        );
        transaction.set(usernameDocRef, {'uid': uid});
        transaction.set(userDocRef, userData, SetOptions(merge: true));

        // Return a fully‐populated User object (including id = uid).
        return user.copyWith(id: uid);
      });

      logger.i("User created successfully (ID: $uid)");
      return createdUser;
    } on EmailAlreadyExistsException catch (e) {
      logger.w(e.toString());
      rethrow;
    } on UsernameAlreadyExistsException catch (e) {
      logger.w(e.toString());
      rethrow;
    } on FirebaseException catch (firebaseErr) {
      // Some Firestore‐level error (permissions, network, etc.)
      logger.e("FirestoreException during createUser: ${firebaseErr.message}");
      throw GenericUserCreationException(
        "Unable to create user: ${firebaseErr.message}",
      );
    } catch (e) {
      logger.e("Unexpected error in createUser: $e");
      throw GenericUserCreationException("Unexpected error: $e");
    }
  }

  @override
  Future<void> updateUser(User user) async {
    await _db
        .collection(FirestoreDbCollections.users)
        .doc(user.id)
        .update(
          user.copyWith(dateCreated: user.dateCreated, id: user.id).toMap(),
        )
        .then((value) {
          logger.i("User ${user.email} update successful!");
        })
        .onError((error, stackTrace) async {
          logger.e("User ${user.email} update error: $error");
        });
  }

  @override
  Future<List<User>?> getUsersById(List<String> listRef) async {
    // If the list is empty, bail out early
    if (listRef.isEmpty) return [];
    assert(listRef.length <= 10, 'List of doc id must be at most 10!');
    try {
      // Firestore allows up to 10 elements in a 'whereIn' query.
      // If listRef.length > 10, you'll need to chunk it into sub‐lists of 10 or fewer.
      // For simplicity, we assume listRef.length <= 10 here.
      final querySnapshot =
          await _db
              .collection(FirestoreDbCollections.users)
              .where(FieldPath.documentId, whereIn: listRef)
              .withConverter<User>(
                fromFirestore: User.fromFirestore,
                toFirestore: (User u, _) => u.toMap(),
              )
              .get();

      final List<User> users =
          querySnapshot.docs
              .map((docSnap) => docSnap.data().copyWith(id: docSnap.id))
              .toList();

      return users;
    } catch (error, _) {
      logger.e("Error in getUsersById: $error");
      throw Exception("Error fetching users by ID: $error");
    }
  }

  @override
  Future<bool> deleteUserById(User user) async {
    final exists = await userExists(user);
    if (!exists) return false;
    return await _db
        .collection(FirestoreDbCollections.users)
        .doc(user.id)
        .delete()
        .then((newUser) {
          logger.i("User ${user.email} deleted with success!");
          return true;
        })
        .onError((error, stackTrace) {
          logger.e(error);
          throw Exception("Error while deleting user: $error");
        });
  }

  Future<bool> userExists(User user) async {
    final emailExists = await getUserByUsername(user.email);
    if (emailExists != null) return true;
    final usernameExists = await getUserByUsername(user.username);
    if (usernameExists != null) return true;
    return false;
  }

  @override
  Future<bool> addSub(String userId, String commId) async {
    try {
      await _usersRef.doc(userId).update({
        'communities_subs': FieldValue.arrayUnion([commId]),
      });
      return true;
    } catch (e) {
      logger.e('Error adding sub $commId from User $userId: $e');
      return false;
    }
  }

  @override
  Future<bool> removeSub(String userId, String commId) async {
    try {
      await _usersRef.doc(userId).update({
        'communities_subs': FieldValue.arrayRemove([commId]),
      });
      return true;
    } catch (e) {
      logger.e('Error removing sub $commId from User $userId: $e');
      return false;
    }
  }
}
