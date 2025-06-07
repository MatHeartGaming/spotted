import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/constants/db_constants.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class FeatureDatasourceMockImpl implements FeatureDatasource {

  final CollectionReference<Feature> _postsRef = FirebaseFirestore.instance
      .collection(FirestoreDbCollections.features)
      .withConverter<Feature>(
        fromFirestore: Feature.fromFirestore,
        toFirestore: (Feature feature, _) => feature.toMap(),
      );

  @override
  Future<List<Feature>> createFeature(Feature newFeature) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockFeatures.add(newFeature);
      return mockFeatures;
    });
  }

  @override
  Future<List<Feature>> getAllFeatures() async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockFeatures;
    });
  }

  @override
  Future<List<Feature>> getFeaturesByName(String name) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockFeatures
          .where(
            (f) =>
                f.name.toLowerCase().trim().contains(name.trim().toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Future<Feature?> getFeatureByName(String name) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockFeatures
          .where(
            (f) => f.name.toLowerCase().trim() == name.trim().toLowerCase(),
          )
          .firstOrNull;
    });
  }

  @override
  Future<Feature?> getFeatureById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockFeatures.where((f) => f.id?.trim() == id).firstOrNull;
    });
  }
}
