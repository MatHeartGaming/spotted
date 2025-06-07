import 'package:spotted/domain/datasources/feature_datasource.dart';
import 'package:spotted/domain/models/feature.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/feature_datasource_mock_impl.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureDatasource _db;

  FeatureRepositoryImpl([FeatureDatasource? db])
    : _db = db ?? FeatureDatasourceMockImpl();

  @override
  Future<List<Feature>> createFeature(Feature newFeature) {
    return _db.createFeature(newFeature);
  }

  @override
  Future<List<Feature>> getAllFeatures() {
    return _db.getAllFeatures();
  }

  @override
  Future<Feature?> getFeatureById(String id) {
    return _db.getFeatureById(id);
  }

  @override
  Future<Feature?> getFeatureByName(String name) {
    return _db.getFeatureByName(name);
  }

  @override
  Future<List<Feature>> getFeaturesByName(String name) {
    return _db.getFeaturesByName(name);
  }

  @override
  Future<List<Feature>> getFeaturesByIds(List<String> ids) {
    return _db.getFeaturesByIds(ids);
  }

  @override
  Future<List<Feature>> createFeaturesIfNotExist(List<Feature> features) {
    return _db.createFeaturesIfNotExist(features);
  }
}
