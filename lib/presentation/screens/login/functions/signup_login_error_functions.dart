import 'package:flutter/material.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';
import 'package:spotted/presentation/widgets/shared/custom_snackbars.dart';

void onSignupError(UserCreationException ex, BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  showCustomSnackbar(context, ex.message, backgroundColor: colors.error);
}
