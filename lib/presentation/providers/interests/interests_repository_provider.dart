import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/interest_datasource_firebase_impl.dart';
import 'package:spotted/infrastructure/repositories/interest_repository_impl.dart';

final interestsRepositoryProvider = Provider<InterestRepository>((ref) {
  return InterestRepositoryImpl(InterestDatasourceFirebaseImpl());
});