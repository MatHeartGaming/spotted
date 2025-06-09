import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/community.dart';

class CommunityDatasourceFirebaseImpl implements CommunityDatasource {
  /// Use a collection converter so that Firestore snapshots map directly to `Community` objects.
  final CollectionReference<Community> _communitiesRef = FirebaseFirestore
      .instance
      .collection(FirestoreDbCollections.communities)
      .withConverter<Community>(
        fromFirestore: Community.fromFirestore,
        toFirestore: (Community community, _) => community.toMap(),
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

  /// Fetch all communities in the `communities` collection.
  @override
  Future<List<Community>> getAllCommunities() async {
    final snapshot = await _communitiesRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all communities where `created_by_id` == [createdById].
  @override
  Future<List<Community>> getCommunitiesByCreatedBy(String createdById) async {
    final snapshot =
        await _communitiesRef
            .where('created_by_id', isEqualTo: createdById)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all communities where `created_by_username` == [createdByUsername].
  @override
  Future<List<Community>> getCommunitiesByCreatedUsername(
    String createdByUsername,
  ) async {
    final snapshot =
        await _communitiesRef
            .where('created_by_username', isEqualTo: createdByUsername)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all communities whose `title` contains [title] (case-insensitive).
  /// Since Firestore doesn't support substring searches on strings, we fetch all and filter client-side.
  @override
  Future<List<Community>> getCommunitiesByTitle(String title) async {
    final lowercaseQuery = title.toLowerCase().trim();
    final allSnapshot = await _communitiesRef.get();
    return allSnapshot.docs
        .map((doc) => doc.data())
        .where(
          (community) =>
              community.title.toLowerCase().trim().contains(lowercaseQuery),
        )
        .toList();
  }

  /// Fetch a single community by its document ID [id], or `null` if not found.
  @override
  Future<Community?> getCommunityById(String id) async {
    final docSnapshot = await _communitiesRef.doc(id).get();
    return docSnapshot.exists ? docSnapshot.data()! : null;
  }

  /// Create a new community with an auto-generated ID from Firestore.
  /// Returns the newly-created `Community` (with its Firebase-generated ID), or `null` on error.
  @override
  Future<Community?> createCommunity(Community community) async {
    try {
      // 1) Get a new DocumentReference with an auto-generated ID.
      final docRef = _communitiesRef.doc();

      // 2) Copy the incoming community, overriding its `id` to match Firestore's ID.
      final communityWithFirebaseId = community.copyWith(id: docRef.id);

      // 3) Write the community data under that ID.
      await docRef.set(communityWithFirebaseId);

      // 4) Return the new Community (now containing the Firestore-generated ID).
      return communityWithFirebaseId;
    } catch (e) {
      logger.e('Error creating community: $e');
      return null;
    }
  }

  /// Update an existing community. If no document with `community.id` exists, returns `null`.
  /// Otherwise returns the updated `Community`.
  @override
  Future<Community?> updateCommunity(Community community) async {
    try {
      final docRef = _communitiesRef.doc(community.id);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        return null;
      }
      // Overwrite the document with the full `Community` data (using our converter).
      await docRef.set(community);
      return community;
    } catch (e) {
      logger.e('Error updating community: $e');
      return null;
    }
  }

  /// Delete the community whose document ID == [id], then return all remaining communities.
  @override
  Future<List<Community>?> deleteCommunityById(String id) async {
    try {
      await _communitiesRef.doc(id).delete();
    } catch (_) {
      // If the document didn't exist or deletion failed, ignore and still return current communities.
    }
    final remaining = await _communitiesRef.get();
    return remaining.docs.map((doc) => doc.data()).toList();
  }

  /// Fetch all communities whose document ID is in [refs].
  /// Uses Firestore’s `FieldPath.documentId` for the query, chunking in batches of 10 if necessary.
  @override
  Future<List<Community>> getCommunitiesUsingUsersCommunityIdList(
    List<String> refs,
  ) async {
    if (refs.isEmpty) return <Community>[];
    final batches = _chunkList<String>(refs, 10);
    final futures = <Future<QuerySnapshot<Community>>>[];

    for (final batch in batches) {
      futures.add(
        _communitiesRef.where(FieldPath.documentId, whereIn: batch).get(),
      );
    }

    final snapshots = await Future.wait(futures);
    final allCommunities = <Community>[];
    for (final snap in snapshots) {
      allCommunities.addAll(snap.docs.map((doc) => doc.data()));
    }
    return allCommunities;
  }

  /// Fetch a single community by its `title` (exact match). Returns `null` if not found.
  @override
  Future<Community?> getCommunityByTitle(String title) async {
    final snapshot =
        await _communitiesRef.where('title', isEqualTo: title).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Future<bool> addSub(String commId, String userId) async {
    try {
      await _communitiesRef.doc(commId).update({
        'subscribed': FieldValue.arrayUnion([userId]),
      });
      return true;
    } catch (e) {
      logger.e('Error adding sub to $commId: $e');
      return false;
    }
  }

  @override
  Future<bool> removeSub(String commId, String userId) async {
    try {
      await _communitiesRef.doc(commId).update({
        'subscribed': FieldValue.arrayRemove([userId]),
      });
      return true;
    } catch (e) {
      logger.e('Error removing sub from $commId: $e');
      return false;
    }
  }
  
  @override
  Future<bool> addPost(String commId, String postId) async {
    try {
      await _communitiesRef.doc(commId).update({
        'posts': FieldValue.arrayUnion([postId]),
      });
      return true;
    } catch (e) {
      logger.e('Error adding post to $commId: $e');
      return false;
    }
  }
  
  @override
  Future<bool> removePost(String commId, String postId) async {
    try {
      await _communitiesRef.doc(commId).update({
        'posts': FieldValue.arrayRemove([postId]),
      });
      return true;
    } catch (e) {
      logger.e('Error removing post to $commId: $e');
      return false;
    }
  }
}
