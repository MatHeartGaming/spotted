// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/presentation/providers/interests/interests_repository_provider.dart';

final interestByIdFutureProvider = FutureProvider.family<Interest?, String>((
  ref,
  id,
) async {
  final interestsRepo = ref.watch(interestsRepositoryProvider);
  return await interestsRepo.getInterestById(id);
});

final loadInterestsProvider =
    StateNotifierProvider<LoadInterestsNotifier, LoadInterestsState>((ref) {
      final interestsRepo = ref.watch(interestsRepositoryProvider);
      final notifier = LoadInterestsNotifier(interestsRepo);
      return notifier;
    });

class LoadInterestsNotifier extends StateNotifier<LoadInterestsState> {
  final InterestRepository _interestRepository;

  LoadInterestsNotifier(this._interestRepository) : super(LoadInterestsState());

  Future<List<Interest>> createInterest(Interest newFeature) async {
    final newInterestsList = await _interestRepository.createInterest(
      newFeature,
    );

    state = state.copyWith(interests: newInterestsList);

    return newInterestsList;
  }

  Future<List<Interest>> getAllInterests() async {
    if (state.isLoadingInterests) return state.interests;
    state = state.copyWith(isLoadingInterests: true);
    final features = await _interestRepository.getAllInterests();

    state = state.copyWith(interests: features, isLoadingInterests: false);

    return features;
  }

  Future<List<Interest>> getInterestsByName(String name) async {
    final interests = await _interestRepository.getInterestsByName(name);
    state = state.copyWith(interestsByName: interests);
    return interests;
  }

  Future<Interest?> getInterestByName(String name) async {
    final feature = await _interestRepository.getInterestByName(name);
    return feature;
  }

  Future<Interest?> getInterestById(String id) async {
    final feature = await _interestRepository.getInterestById(id);
    return feature;
  }
}

class LoadInterestsState {
  final List<Interest> interests;
  final List<Interest> interestsByName;
  final bool isLoadingInterests;

  LoadInterestsState({
    this.interests = const [],
    this.interestsByName = const [],
    this.isLoadingInterests = false,
  });

  @override
  bool operator ==(covariant LoadInterestsState other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.interests, interests) &&
      listEquals(other.interestsByName, interestsByName) &&
      other.isLoadingInterests == isLoadingInterests;
  }

  @override
  int get hashCode => interests.hashCode ^ interestsByName.hashCode ^ isLoadingInterests.hashCode;

  LoadInterestsState copyWith({
    List<Interest>? interests,
    List<Interest>? interestsByName,
    bool? isLoadingInterests,
  }) {
    return LoadInterestsState(
      interests: interests ?? this.interests,
      interestsByName: interestsByName ?? this.interestsByName,
      isLoadingInterests: isLoadingInterests ?? this.isLoadingInterests,
    );
  }
}
