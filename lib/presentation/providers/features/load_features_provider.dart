// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/feature.dart';
import 'package:spotted/domain/repositories/feature_repository.dart';
import 'package:spotted/presentation/providers/features/feature_repository_provider.dart';

final featureByIdFutureProvider = FutureProvider.family<Feature?, String>((
  ref,
  id,
) async {
  final featuresRepo = ref.watch(featureRepositoryProvider);
  return await featuresRepo.getFeatureById(id);
});

final loadFeaturesProvider =
    StateNotifierProvider<LoadFeaturesNotifier, LoadFeaturesState>((ref) {
      final featuresRepo = ref.watch(featureRepositoryProvider);
      final notifier = LoadFeaturesNotifier(featuresRepo);
      return notifier;
    });

class LoadFeaturesNotifier extends StateNotifier<LoadFeaturesState> {
  final FeatureRepository _featureRepository;

  LoadFeaturesNotifier(this._featureRepository) : super(LoadFeaturesState());

  Future<List<Feature>> createFeature(Feature newFeature) async {
    final newFeatureList = await _featureRepository.createFeature(newFeature);

    state = state.copyWith(features: newFeatureList);

    return newFeatureList;
  }

  Future<List<Feature>> getAllFeatures() async {
    if (state.isLoadingFeatures) return state.features;
    state = state.copyWith(isLoadingFeatures: true);
    final features = await _featureRepository.getAllFeatures();

    state = state.copyWith(features: features, isLoadingFeatures: false);

    return features;
  }

  Future<List<Feature>> getFeaturesByName(String name) async {
    final features = await _featureRepository.getFeaturesByName(name);
    return features;
  }

  Future<Feature?> getFeatureByName(String name) async {
    final feature = await _featureRepository.getFeatureByName(name);
    return feature;
  }

  Future<Feature?> getFeatureById(String id) async {
    final feature = await _featureRepository.getFeatureById(id);
    return feature;
  }
}

class LoadFeaturesState {
  final List<Feature> features;
  final bool isLoadingFeatures;

  LoadFeaturesState({this.features = const [], this.isLoadingFeatures = false});

  @override
  bool operator ==(covariant LoadFeaturesState other) {
    if (identical(this, other)) return true;

    return listEquals(other.features, features) &&
        other.isLoadingFeatures == isLoadingFeatures;
  }

  @override
  int get hashCode => features.hashCode ^ isLoadingFeatures.hashCode;

  LoadFeaturesState copyWith({
    List<Feature>? features,
    bool? isLoadingFeatures,
  }) {
    return LoadFeaturesState(
      features: features ?? this.features,
      isLoadingFeatures: isLoadingFeatures ?? this.isLoadingFeatures,
    );
  }
}
