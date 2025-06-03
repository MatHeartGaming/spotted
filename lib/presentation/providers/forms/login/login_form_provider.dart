import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';
import 'package:spotted/presentation/providers/forms/states/signup_form_state.dart';

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, SignupFormState>((ref) {
  final loginNotifier = LoginNotifier();
  return loginNotifier;
});

class LoginNotifier extends StateNotifier<SignupFormState> {
  LoginNotifier() : super(const SignupFormState());

  void onSubmit({required VoidCallback onSubmit}) {
    List<FormzInput> fieldsToValidate = [
      state.email,
      state.password,
    ];

    state = state.copyWith(
      status: FormStatus.posting,
      email: Email.dirty(state.email.value),
      password: PasswordText.dirty(state.password.value),
      isValid: Formz.validate(fieldsToValidate),
    );

    if (!state.isValid) return;

    onSubmit();
  }

  void passwordChanged(String value) {
    final password = PasswordText.dirty(value);
    List<FormzInput> fieldsToValidate = [
      state.email,
      password,
    ];
    state = state.copyWith(
      password: password,
      isValid:
          Formz.validate(fieldsToValidate),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    List<FormzInput> fieldsToValidate = [
      email,
      state.password,
    ];
    state = state.copyWith(
      email: email,
      isValid: Formz.validate(fieldsToValidate),
    );
  }

  void clearFormState() {
    state = state.copyWith(
      email: const Email.pure(),
      password: const PasswordText.pure(),
    );
  }
}
