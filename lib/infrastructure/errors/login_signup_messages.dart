import 'package:easy_localization/easy_localization.dart';

enum LoginSignupMessages {
  success,
  weakPassword,
  emailAlreadyExists,
  userNotFound,
  invalidCredentials,
  tooManyAttempts,
  wrongPassword,
  unkownError
}

String getLoginSignupMessage(LoginSignupMessages mex) {
  switch (mex) {
    case LoginSignupMessages.success:
      return "login_signupe_success".tr();
    case LoginSignupMessages.weakPassword:
      return "Llogin_signupe_weak_password_error".tr();

    case LoginSignupMessages.emailAlreadyExists:
      return "login_signupe_email_already_exists_error".tr();

    case LoginSignupMessages.unkownError:
      return "login_signupe_unknown_error_error".tr();

    case LoginSignupMessages.userNotFound:
      return "login_signupe_user_not_found_error".tr();

    case LoginSignupMessages.wrongPassword:
      return "login_signupe_wrong_password_error".tr();
    case LoginSignupMessages.invalidCredentials:
      return "login_signupe_invalid_credentials_error".tr();
    case LoginSignupMessages.tooManyAttempts:
      return "login_signupe_too_many_attempts_error".tr();
  }
}
