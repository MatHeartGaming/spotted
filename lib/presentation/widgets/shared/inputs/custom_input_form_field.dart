import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotted/presentation/widgets/shared/inputs/currency_input_formatter.dart';
import 'package:spotted/presentation/widgets/shared/inputs/phone_number_input_formatter.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final IconData? icon;
  final Widget? trailingIcon;
  final String? errorMessage;
  final bool obscureText;
  final bool enabled;
  final bool autoFocus;
  final double borderRaius;
  final FormInputFormatters formatter;
  final Iterable<String> autoFillHints;
  final Function(String)? onChanged;
  final VoidCallback? onSubmitForm;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.onChanged,
    this.validator,
    this.errorMessage,
    this.trailingIcon,
    this.obscureText = false,
    this.enabled = true,
    this.autoFocus = false,
    this.icon,
    this.borderRaius = 20,
    this.initialValue,
    this.autoFillHints = const [],
    this.onSubmitForm,
    this.formatter = FormInputFormatters.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRaius),
    );
    return TextFormField(
      controller: controller,
      autofillHints: autoFillHints,
      initialValue: initialValue,
      enabled: enabled,
      autofocus: autoFocus,
      keyboardType: formatter == FormInputFormatters.phone
          ? TextInputType.phone
          : (formatter == FormInputFormatters.digits
              ? const TextInputType.numberWithOptions(decimal: true)
              : (formatter == FormInputFormatters.email
                  ? TextInputType.emailAddress
                  : TextInputType.text)),
      inputFormatters: formatter == FormInputFormatters.phone
          ? <TextInputFormatter>[
              PhoneNumberInputFormatter(),
            ]
          : (formatter == FormInputFormatters.digits
              ? <TextInputFormatter>[
                  CurrencyInputFormatter(),
                ]
              : null),
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      onFieldSubmitted: (_) {
        if (onSubmitForm == null) return;
        onSubmitForm!(); // Submit the form when "Done" is pressed
      },
      decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder:
              border.copyWith(borderSide: BorderSide(color: colors.primary)),
          isDense: true,
          label: Text(label ?? ""),
          hintText: hint,
          suffixIcon: trailingIcon,
          prefixIcon: Icon(
            icon,
            color: colors.inversePrimary,
          ),
          focusColor: colors.primary,
          focusedErrorBorder:
              border.copyWith(borderSide: BorderSide(color: colors.error)),
          errorBorder:
              border.copyWith(borderSide: BorderSide(color: colors.error)),
          errorText: errorMessage),
    );
  }
}

enum FormInputFormatters { text, digits, email, phone }
