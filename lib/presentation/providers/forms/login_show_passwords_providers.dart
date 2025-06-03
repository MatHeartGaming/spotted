
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showPasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final showRepeatPasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});