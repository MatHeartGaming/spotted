import 'package:easy_localization/easy_localization.dart';
import 'package:formz/formz.dart';
import 'package:spotted/config/config.dart';

enum EmailError { format, length }

// Extend FormzInput and provide the input type and error type.
class Email extends FormzInput<String, EmailError> {
  // Call super.pure to represent an unmodified form input.
  const Email.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Email.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    //if (displayError == EmailError.length) return 'Minimo 6 caratteri';
    if (displayError == EmailError.format) {
      return "form_error_email_not_valid".tr();
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  EmailError? validator(String value) {
    if (value.trim().length < 6) return EmailError.length;
    if (!isEmailValid(value)) return EmailError.format;
    return null;
  }
}
