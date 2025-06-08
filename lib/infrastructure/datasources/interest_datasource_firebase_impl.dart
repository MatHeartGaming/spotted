import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/constants/db_constants.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';

/// Firebase-backed implementation of [InterestDatasource].
/// Uses auto-generated document IDs as interest IDs.
class InterestDatasourceFirebaseImpl implements InterestDatasource {
  final CollectionReference<Interest> _interestsRef = FirebaseFirestore.instance
      .collection(FirestoreDbCollections.interests)
      .withConverter<Interest>(
        fromFirestore: Interest.fromFirestore,
        toFirestore: (Interest interest, _) => interest.toMap(),
      );

  @override
  Future<List<Interest>> createInterest(Interest newInterest) async {
    // Add the interest; Firestore generates an ID.
    final docRef = await _interestsRef.add(newInterest);
    // Optionally, save the generated ID back into the document itself:
    await docRef.update({'id': docRef.id});
    // Return the updated list of all interests.
    return getAllInterests();
  }

  @override
  Future<List<Interest>> getAllInterests() async {
    final snapshot = await _interestsRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<Interest>> getInterestsByName(String name) async {
    // For prefix-based search; change to array-contains or full-text if needed
    final query = _interestsRef
        .where('name_lower_cased', isGreaterThanOrEqualTo: name.trim().toLowerCase())
        .where(
          'name_lower_cased',
          isLessThanOrEqualTo: '${name.trim().toLowerCase()}\uf8ff',
        );
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<Interest?> getInterestByName(String name) async {
    final snapshot =
        await _interestsRef
            .where('name', isEqualTo: name.trim().toLowerCase())
            .limit(1)
            .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Future<Interest?> getInterestById(String id) async {
    final doc = await _interestsRef.doc(id).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Future<List<Interest>> getInterestsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    const chunkSize = 10;
    final List<Interest> results = [];

    for (var i = 0; i < ids.length; i += chunkSize) {
      final end = (i + chunkSize < ids.length) ? i + chunkSize : ids.length;
      final chunk = ids.sublist(i, end);

      final snapshot =
          await _interestsRef.where(FieldPath.documentId, whereIn: chunk).get();
      results.addAll(snapshot.docs.map((d) => d.data()));
    }

    return results;
  }

  @override
  Future<List<Interest>> createInterestIfNotExist(
    List<Interest> interests,
  ) async {
    if (interests.isEmpty) return [];

    // Prepare normalized names set
    final names =
        interests.map((f) => f.name.trim().toLowerCase()).toSet().toList();

    // Fetch existing features by name in chunks
    final existingNames = <String>{};
    const chunkSize = 10;
    for (var i = 0; i < names.length; i += chunkSize) {
      final end = i + chunkSize < names.length ? i + chunkSize : names.length;
      final chunk = names.sublist(i, end);
      final snapshot = await _interestsRef.where('name', whereIn: chunk).get();
      existingNames.addAll(
        snapshot.docs.map((d) => d.data().name.trim().toLowerCase()),
      );
    }

    // Filter out duplicates
    final toAdd =
        interests
            .where((i) => !existingNames.contains(i.name.trim().toLowerCase()))
            .toList();
    if (toAdd.isEmpty) return [];

    // Batch write new features
    final batch = FirebaseFirestore.instance.batch();
    final created = <Interest>[];
    for (var interest in toAdd) {
      final docRef = _interestsRef.doc();
      final withId = interest.copyWith(id: docRef.id);
      batch.set(docRef, withId);
      created.add(withId);
    }
    await batch.commit();
    return created;
  }
}
