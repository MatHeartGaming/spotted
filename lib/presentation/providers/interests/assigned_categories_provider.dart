
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';

final assignedInterestProvider = StateProvider.autoDispose<List<Interest>>((ref) {
  return [];
});