// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> sendResetPasswordEmail(WidgetRef ref, [String? email]) async {
  /*final authRepository = ref.read(authPasswordRepositoryProvider);
  // User is not logged in
  if (email != null && isEmailValid(email)) {
    authRepository.sendPasswordResetLink(email: email).then(
      (value) {
        showCustomSnackbar(
            ref.context,
            "login_screen_email_verification_sent_snackbar"
                .tr(args: [email]));
      },
    );
    return;
  }*/
  // User is already logged in
  _sendResetLinkForLoggedInUser(ref);
}

Future<void> _sendResetLinkForLoggedInUser(WidgetRef ref) async {
  /*final authRepository = ref.read(authPasswordRepositoryProvider);
  await authRepository.isUserEmailVerified().then(
    (isUserEmailVerified) {
      if (isUserEmailVerified) {
        authRepository.sendPasswordResetLink().then(
          (value) {
            showCustomSnackbar(
                ref.context,
                "login_screen_email_verification_sent_snackbar"
                    .tr(args: [authRepository.signedInUserEmail]));
          },
        );
      }
    },
  );*/
}
