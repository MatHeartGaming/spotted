import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final tabBarVisibilityProvider = StateProvider<bool>((ref) => true);

final tabBarControllerProvider = StateProvider<TabController?>((ref) => null);
