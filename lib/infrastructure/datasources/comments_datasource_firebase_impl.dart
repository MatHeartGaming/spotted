import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/comment.dart';

class CommentsDatasourceFirebaseImpl implements CommentsDatasource {
  /// Use a collection converter so that Firestore snapshots map directly to `Comment` objects.
  final CollectionReference<Comment> _commentsRef = FirebaseFirestore.instance
      .collection(FirestoreDbCollections.comments)
      .withConverter<Comment>(
        fromFirestore: Comment.fromFirestore,
        toFirestore: (Comment comment, _) => comment.toMap(),
      );

  /// Create a new comment with an auto-generated ID from Firestore.
  /// Returns the newly-created `Comment` (with its Firebase-generated `id`), or `null` on error.
  @override
  Future<Comment?> createComment(Comment comment) async {
    try {
      // 1) Get a new DocumentReference with an auto-generated ID.
      final docRef = _commentsRef.doc();

      // 2) Copy the incoming `comment`, overriding its `id` to match Firestore's ID.
      final commentWithFirebaseId = comment.copyWith(id: docRef.id);

      // 3) Write the comment data under that ID.
      await docRef.set(commentWithFirebaseId);

      // 4) Return the new Comment (now containing the Firestore-generated ID).
      return commentWithFirebaseId;
    } catch (e) {
      logger.e('Error creating comment: $e');
      return null;
    }
  }

  /// Update an existing comment document with the data in [comment].
  /// If no document with `comment.id` exists, returns `null`. Otherwise returns the updated `Comment`.
  @override
  Future<Comment?> updateComment(Comment comment) async {
    try {
      final docRef = _commentsRef.doc(comment.id);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        return null;
      }
      // Overwrite the document with the full `Comment` data (using our converter).
      await docRef.set(comment);
      return comment;
    } catch (e) {
      logger.e('Error updating comment: $e');
      return null;
    }
  }

  /// Delete the comment whose document ID == [id], then return all remaining comments.
  @override
  Future<List<Comment>> deleteCommentById(String id) async {
    try {
      await _commentsRef.doc(id).delete();
    } catch (_) {
      // If the document didn't exist or deletion failed, ignore and still return current comments.
    }
    final remaining = await _commentsRef.get();
    return remaining.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch a single comment by its document ID [id]. Returns a one-element list if found, otherwise an empty list.
  @override
  Future<List<Comment>> getCommentById(String id) async {
    final docSnapshot = await _commentsRef.doc(id).get();
    if (!docSnapshot.exists) {
      return <Comment>[];
    }
    return [docSnapshot.data()!];
  }

  /// Fetch all comments where `created_by_id` == [createdById].
  @override
  Future<List<Comment>> getCommentsByCreatedById(String createdById) async {
    final querySnapshot =
        await _commentsRef
            .where('created_by_id', isEqualTo: createdById)
            .orderBy('date_created', descending: true)
            .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all comments where `created_by_username` == [createdByUsername].
  @override
  Future<List<Comment>> getCommentsByCreatedByUsername(
    String createdByUsername,
  ) async {
    final querySnapshot =
        await _commentsRef
            .where('created_by_username', isEqualTo: createdByUsername)
            .orderBy('date_created', descending: true)
            .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all comments where `post_id` == [postId].
  @override
  Future<List<Comment>> getCommentsByPostId(String postId) async {
    final querySnapshot =
        await _commentsRef
            .where('post_id', isEqualTo: postId)
            .orderBy('date_created', descending: true)
            .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all comments where `posted_in` == [postedIn].
  @override
  Future<List<Comment>> getCommentsByPostedInCommunity(String postedIn) async {
    final querySnapshot =
        await _commentsRef
            .where('posted_in', isEqualTo: postedIn)
            .orderBy('date_created', descending: true)
            .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
