import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/post.dart';

class PostsDatasourceFirebaseImpl implements PostsDatasource {
  /// Use a collection converter so that Firestore snapshots map directly to `Post` objects.
  final CollectionReference<Post> _postsRef = FirebaseFirestore.instance
      .collection(FirestoreDbCollections.posts)
      .withConverter<Post>(
        fromFirestore: Post.fromFirestore,
        toFirestore: (Post post, _) => post.toMap(),
      );

  /// Helper to split any list into chunks of size at most [batchSize].
  List<List<T>> _chunkList<T>(List<T> items, int batchSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < items.length; i += batchSize) {
      final end = (i + batchSize > items.length) ? items.length : i + batchSize;
      chunks.add(items.sublist(i, end));
    }
    return chunks;
  }

  /// Create a new post document whose ID == `post.id`.
  /// Returns the same `Post` on success, or `null` on any error.
  @override
  Future<Post?> createPost(Post post) async {
    try {
      // 1) Ask Firestore for a new document reference (with an auto‐generated ID)
      final docRef = _postsRef.doc(); // <-- no arguments => gets a new ID

      // 2) Create a copy of your `post`, but override its `id` to match Firestore’s new ID
      final postWithFirebaseId = post.copyWith(id: docRef.id);

      // 3) Write that copy under the new ID
      await docRef.set(postWithFirebaseId);

      // 4) Return the “official” post (with `id == docRef.id`)
      return postWithFirebaseId;
    } catch (e) {
      logger.e('Error while creating Post: $e');
      return null;
    }
  }

  /// Update an existing post document. If no document with `post.id` exists, returns null.
  @override
  Future<Post?> updatePost(Post post) async {
    try {
      final docRef = _postsRef.doc(post.id);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        return null;
      }
      // Overwrite the document with the full `Post` data.
      await docRef.set(post);
      return post;
    } catch (e) {
      logger.e('Error while updating Post: $e');
      return null;
    }
  }

  /// Fetch all posts in the `posts` collection.
  @override
  @override
  Future<List<Post>> getAllPosts() async {
    final querySnapshot =
        await _postsRef.orderBy('date_created', descending: true).get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all posts whose `content` contains [content] (case-insensitive).
  /// Since Firestore doesn't support arbitrary substring searches, we fetch all and filter client-side.
  @override
  Future<List<Post>> getAllPostsByContent(String content) async {
    final lowercaseQuery = content.toLowerCase().trim();
    final allPostsSnapshot =
        await _postsRef.orderBy('date_created', descending: true).get();
    return allPostsSnapshot.docs
        .map((doc) => doc.data())
        .where(
          (post) => post.content.toLowerCase().trim().contains(lowercaseQuery),
        )
        .toList();
  }

  /// Fetch all posts where `created_by_id` == [id].
  @override
  Future<List<Post>> getAllPostsByCreatedById(String id) async {
    final querySnapshot =
        await _postsRef
            .where('created_by_id', isEqualTo: id)
            .orderBy('date_created', descending: true)
            .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all posts where `created_by_username` == [username].
  @override
  Future<List<Post>> getAllPostsByCreatedByUsername(String username) async {
    final querySnapshot =
        await _postsRef
            .where('created_by_username', isEqualTo: username)
            .orderBy('date_created', descending: true)
            .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all posts whose `title` contains [title] (case-insensitive).
  /// As Firestore can't do substring matches, we read everything and filter client-side.
  @override
  Future<List<Post>> getAllPostsByTitle(String title) async {
    final lowercaseQuery = title.toLowerCase().trim();

    // 1) Ask Firestore for all posts ordered by date
    final allPostsSnapshot =
        await _postsRef.orderBy('date_created', descending: true).get();

    // 2) Filter client‐side on substring match
    return allPostsSnapshot.docs
        .map((doc) => doc.data())
        .where(
          (post) => post.title.toLowerCase().trim().contains(lowercaseQuery),
        )
        .toList();
  }

  /// Fetch posts whose document ID == [id]. Returns a single-element list if found, else empty.
  @override
  Future<List<Post>> getPostsById(String id) async {
    final docSnapshot = await _postsRef.doc(id).get();
    if (!docSnapshot.exists) {
      return <Post>[];
    }
    return [docSnapshot.data()!];
  }

  /// Fetch a single `Post` by its document ID [id], or `null` if not found.
  @override
  Future<Post?> getPostById(String id) async {
    final docSnapshot = await _postsRef.doc(id).get();
    return docSnapshot.exists ? docSnapshot.data()! : null;
  }

  /// Delete the post document whose ID == [postedIn] (here, that argument is treated as post ID),
  /// then return the list of all remaining posts.
  @override
  Future<List<Post>> deletePostById(String postedIn) async {
    try {
      await _postsRef.doc(postedIn).delete();
    } catch (_) {
      // If the document doesn't exist or deletion fails, ignore and still return current posts.
    }
    final remaining = await _postsRef.get();
    return remaining.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all posts where `created_by_id` is in [refs]. Firestore's `whereIn` is limited to 10 items,
  /// so we chunk the list if needed.
  @override
  Future<List<Post>> getPostsUsingUsersIdListRef(List<String> refs) async {
    if (refs.isEmpty) return <Post>[];
    final batches = _chunkList<String>(refs, 10);
    final futures = <Future<QuerySnapshot<Post>>>[];

    for (final batch in batches) {
      futures.add(
        _postsRef
            .where('created_by_id', whereIn: batch)
            .orderBy('date_created', descending: true)
            .get(),
      );
    }

    final snapshots = await Future.wait(futures);
    final allPosts = <Post>[];
    for (final snap in snapshots) {
      allPosts.addAll(snap.docs.map((doc) => doc.data()));
    }
    return allPosts;
  }

  /// Fetch all posts where `created_by_username` is in [refs], honoring Firestore's 10‐element limit per `whereIn`.
  @override
  Future<List<Post>> getPostsUsingUsernamesList(List<String> refs) async {
    if (refs.isEmpty) return <Post>[];
    final batches = _chunkList<String>(refs, 10);
    final futures = <Future<QuerySnapshot<Post>>>[];

    for (final batch in batches) {
      futures.add(
        _postsRef
            .where('created_by_username', whereIn: batch)
            .orderBy('date_created', descending: true)
            .get(),
      );
    }

    final snapshots = await Future.wait(futures);
    final allPosts = <Post>[];
    for (final snap in snapshots) {
      allPosts.addAll(snap.docs.map((doc) => doc.data()));
    }
    return allPosts;
  }

  /// Fetch all posts where `posted_in` == [postedIn].
  @override
  Future<List<Post>> getAllPostsByPostedIn(String postedIn) async {
    final querySnapshot =
        await _postsRef.where('posted_in', isEqualTo: postedIn).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all posts whose `posted_in` field is in [refs], respecting Firestore's 10‐element `whereIn` limit.
  @override
  Future<List<Post>> getPostsUsingPostedInList(List<String> refs) async {
    if (refs.isEmpty) return <Post>[];
    final batches = _chunkList<String>(refs, 10);
    final futures = <Future<QuerySnapshot<Post>>>[];

    for (final batch in batches) {
      futures.add(
        _postsRef
            .where('posted_in', whereIn: batch)
            .orderBy('date_created', descending: true)
            .get(),
      );
    }

    final snapshots = await Future.wait(futures);
    final allPosts = <Post>[];
    for (final snap in snapshots) {
      allPosts.addAll(snap.docs.map((doc) => doc.data()));
    }
    return allPosts;
  }

  /// Fetch all posts whose document ID is in [refs]. Uses `FieldPath.documentId` for the query.
  @override
  Future<List<Post>> getPostsUsingUsersPostedIdList(List<String> refs) async {
    if (refs.isEmpty) return <Post>[];
    final batches = _chunkList<String>(refs, 10);
    final futures = <Future<QuerySnapshot<Post>>>[];

    for (final batch in batches) {
      futures.add(
        _postsRef
            .where(FieldPath.documentId, whereIn: batch)
            .orderBy('date_created', descending: true)
            .get(),
      );
    }

    final snapshots = await Future.wait(futures);
    final allPosts = <Post>[];
    for (final snap in snapshots) {
      allPosts.addAll(snap.docs.map((doc) => doc.data()));
    }
    return allPosts;
  }

  @override
  Future<bool> addComment(String postId, String commentId) async {
    try {
      await _postsRef.doc(postId).update({
        'comment_ids': FieldValue.arrayUnion([commentId]),
      });
      return true;
    } catch (e) {
      logger.e('Error adding comment to $postId: $e');
      return false;
    }
  }

  @override
  Future<bool> removeComment(String postId, String commentId) async {
    try {
      await _postsRef.doc(postId).update({
        'comment_ids': FieldValue.arrayRemove([commentId]),
      });
      return true;
    } catch (e) {
      logger.e('Error removing comment from $postId: $e');
      return false;
    }
  }

  @override
  Future<bool> addReaction(String postId, String userId, String reaction) async {
    try {
      // This will set or overwrite only the key `reactions.userId`
      await _postsRef.doc(postId).update({
        'reactions.$userId': reaction,
      });
      return true;
    } catch (e) {
      logger.e('Error adding reaction to $postId by $userId: $e');
      return false;
    }
  }

  @override
  Future<bool> removeReaction(String postId, String userId) async {
    try {
      // FieldValue.delete() removes the map entry at reactions.userId
      await _postsRef.doc(postId).update({
        'reactions.$userId': FieldValue.delete(),
      });
      return true;
    } catch (e) {
      logger.e('Error removing reaction from $postId by $userId: $e');
      return false;
    }
  }
}