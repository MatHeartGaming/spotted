// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/constants/regular_expressions.dart';
import 'package:spotted/config/helpers/haptic_feedback.dart';
import 'package:spotted/presentation/providers/providers.dart';

import '../../../presentation/widgets/shared/custom_snackbars.dart'
    show showCustomSnackbar;

Future<void> sendResetPasswordEmail(WidgetRef ref, [String? email]) async {
  final authRepository = ref.read(authPasswordRepositoryProvider);
  // User is not logged in
  if (email != null && isEmailValid(email)) {
    authRepository.sendPasswordResetLink(email: email).then((value) {
      mediumVibration();
      showCustomSnackbar(
        ref.context,
        "login_screen_email_verification_sent_snackbar".tr(args: [email]),
      );
    });
    return;
  }
  // User is already logged in
  _sendResetLinkForLoggedInUser(ref);
}

Future<void> _sendResetLinkForLoggedInUser(WidgetRef ref) async {
  final authRepository = ref.read(authPasswordRepositoryProvider);
  await authRepository.isUserEmailVerified().then((isUserEmailVerified) {
    if (isUserEmailVerified) {
      authRepository.sendPasswordResetLink().then((value) {
        mediumVibration();
        showCustomSnackbar(
          ref.context,
          "login_screen_email_verification_sent_snackbar".tr(
            args: [authRepository.signedInUserEmail],
          ),
        );
      });
    }
  });
}
