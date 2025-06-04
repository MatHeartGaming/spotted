import 'package:spotted/domain/models/models.dart';

abstract class FeatureDatasource {
  Future<List<Feature>> createFeature(Feature newFeature);
  Future<List<Feature>> getAllFeatures();
  Future<List<Feature>> getFeaturesByName(String name);
  Future<Feature?> getFeatureByName(String name);
  Future<Feature?> getFeatureById(String id);
}
