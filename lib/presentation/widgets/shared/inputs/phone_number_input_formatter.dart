import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  final validationRegex = RegExp(r'^\+?\d*$'); // Flexible for typing.

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!validationRegex.hasMatch(newValue.text)) {
      return oldValue; // Revert if invalid.
    }
    return newValue;
  }
}