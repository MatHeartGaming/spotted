import 'package:formz/formz.dart';
import 'package:spotted/config/config.dart';

enum PasswordTextError { empty, length, complexity }

class PasswordText extends FormzInput<String, PasswordTextError> {
  final int _minLenght = 12;

  // Call super.pure to represent an unmodified form input.
  const PasswordText.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const PasswordText.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordTextError.empty) {
      return 'Il campo non può essere vuoto';
    }
    if (displayError == PasswordTextError.length) {
      return 'Il campo deve avere almeno $_minLenght caratteri';
    }
    if (displayError == PasswordTextError.complexity) {
      return 'Almeno $_minLenght caratteri, una lettera maiscula, un numero e un carattere speciale (@\$!%*?&)';
    }
    return null;
  }

  @override
  PasswordTextError? validator(String value) {
    if (value.trim().isEmpty) return PasswordTextError.empty;
    if (value.trim().length < _minLenght) return PasswordTextError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordTextError.complexity;
    return null;
  }
}
