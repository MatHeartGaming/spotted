
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';

final assignedFeaturesProvider = StateProvider.autoDispose<List<Feature>>((ref) {
  return [];
});