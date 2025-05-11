import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/theme/app_theme.dart';

// Un objeto de tipo AppTheme (custom). El que controla es ThemeNotifier, la instancia es de AppTheme.
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  final themeNotifier = ThemeNotifier();
  return themeNotifier;
});

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void onAppPrimaryColorChanged(Color color) {
    state = state.copyWith(customColor: color);
  }
}
