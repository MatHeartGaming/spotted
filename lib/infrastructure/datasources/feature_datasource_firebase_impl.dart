import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/constants/db_constants.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';

/// Firebase-backed implementation of [FeatureDatasource].
/// Uses auto-generated document IDs as feature IDs.
class FeatureDatasourceFirebaseImpl implements FeatureDatasource {
  final CollectionReference<Feature> _featuresRef =
      FirebaseFirestore.instance
          .collection(FirestoreDbCollections.features)
          .withConverter<Feature>(
            fromFirestore: Feature.fromFirestore,
            toFirestore: (Feature feature, _) => feature.toMap(),
          );

  @override
  Future<List<Feature>> createFeature(Feature newFeature) async {
    // Add the feature; Firestore generates an ID.
    final docRef = await _featuresRef.add(newFeature);
    // Optionally, update the document to include its own ID field:
    await docRef.update({'id': docRef.id});
    // Return the updated list of all features.
    return getAllFeatures();
  }

  @override
  Future<List<Feature>> getAllFeatures() async {
    final snapshot = await _featuresRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<Feature>> getFeaturesByName(String name) async {
    // Performs a prefix query for simplicity. Adjust for substring search if needed.
    final query = _featuresRef
        .where('name_lower_cased', isGreaterThanOrEqualTo: name.trim().toLowerCase())
        .where(
          'name_lower_cased',
          isLessThanOrEqualTo: '${name.trim().toLowerCase()}\uf8ff',
        );
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<Feature?> getFeatureByName(String name) async {
    final snapshot = await _featuresRef
        .where('name', isEqualTo: name.trim().toLowerCase())
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Future<Feature?> getFeatureById(String id) async {
    final doc = await _featuresRef.doc(id).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Future<List<Feature>> getFeaturesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    // Firestore limits 'whereIn' to 10 values per query
    const chunkSize = 10;
    final List<Feature> results = [];

    for (var i = 0; i < ids.length; i += chunkSize) {
      final end = (i + chunkSize < ids.length) ? i + chunkSize : ids.length;
      final chunk = ids.sublist(i, end);

      final snapshot = await _featuresRef
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(snapshot.docs.map((d) => d.data()));
    }

    return results;
  }

  @override
  Future<List<Feature>> createFeaturesIfNotExist(List<Feature> features) async {
    if (features.isEmpty) return [];

    // Prepare normalized names set
    final names = features
        .map((f) => f.name.trim().toLowerCase())
        .toSet()
        .toList();

    // Fetch existing features by name in chunks
    final existingNames = <String>{};
    const chunkSize = 10;
    for (var i = 0; i < names.length; i += chunkSize) {
      final end = i + chunkSize < names.length ? i + chunkSize : names.length;
      final chunk = names.sublist(i, end);
      final snapshot = await _featuresRef
          .where('name', whereIn: chunk)
          .get();
      existingNames.addAll(
        snapshot.docs
            .map((d) => d.data().name.trim().toLowerCase()),
      );
    }

    // Filter out duplicates
    final toAdd = features
        .where(
          (f) => !existingNames.contains(f.name.trim().toLowerCase()),
        )
        .toList();
    if (toAdd.isEmpty) return [];

    // Batch write new features
    final batch = FirebaseFirestore.instance.batch();
    final created = <Feature>[];
    for (var feature in toAdd) {
      final docRef = _featuresRef.doc();
      final withId = feature.copyWith(id: docRef.id);
      //batch.set(docRef, withId.toMap());
      batch.set(docRef, withId);
      created.add(withId);
    }
    await batch.commit();
    return created;
  }
}
