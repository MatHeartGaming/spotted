import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/feature_repository.dart';
import 'package:spotted/infrastructure/repositories/repositories.dart';

final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  return FeatureRepositoryImpl();
});
