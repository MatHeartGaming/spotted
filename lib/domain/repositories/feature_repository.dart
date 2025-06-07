import 'package:spotted/domain/models/models.dart' show Feature;

abstract class FeatureRepository {
  Future<List<Feature>> createFeature(Feature newFeature);
  Future<List<Feature>> getAllFeatures();
  Future<List<Feature>> getFeaturesByName(String name);
  Future<Feature?> getFeatureByName(String name);
  Future<Feature?> getFeatureById(String id);
  Future<List<Feature>> getFeaturesByIds(List<String> ids);
  Future<List<Feature>> createFeaturesIfNotExist(List<Feature> features);
}
