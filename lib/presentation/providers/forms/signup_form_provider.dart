import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';
import 'package:spotted/presentation/providers/forms/states/signup_form_state.dart';

final signupFormProvider =
    StateNotifierProvider.autoDispose<SignupNotifier, SignupFormState>((ref) {
      final signupNotifier = SignupNotifier();
      return signupNotifier;
    });

class SignupNotifier extends StateNotifier<SignupFormState> {
  SignupNotifier()
    : super(
        SignupFormState(
          nameController: TextEditingController(),
          surnameController: TextEditingController(),
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          repeatPasswordController: TextEditingController(),
          usernameController: TextEditingController(),
          countryController: TextEditingController(),
          cityController: TextEditingController(),
        ),
      );

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void initFormField(User user) {
    state.nameController?.text = user.name;
    state.surnameController?.text = user.surname;
    state.emailController?.text = user.email;
    state.usernameController?.text = user.username;
    //state.usernameController?.text = user.username;
    //state.usernameController?.text = user.username;
    state = state.copyWith(
      nameController: state.nameController,
      surnameController: state.surnameController,
      emailController: state.emailController,
      usernameController: state.usernameController,
      name: GenericText.dirty(user.name),
      surname: GenericText.dirty(user.surname),
      username: GenericText.dirty(user.username),
      email: Email.dirty(user.email),
      status: FormStatus.invalid,
      isValid: false,
    );
  }

  void onSubmit({
    required VoidCallback onSubmit,
    bool validatePasswords = true,
    bool allowNonVatUserSignup = true,
    VoidCallback? onPasswordMismatch,
  }) {
    List<FormzInput> fieldsToValidate = [
      state.email,
      state.name,
      state.surname,
      state.username,
      state.city,
      state.country,
      state.password,
      state.repeatPassword,
    ];

    if (!validatePasswords) {
      fieldsToValidate.removeRange(
        fieldsToValidate.length - 2,
        fieldsToValidate.length,
      );
      logger.i('Validate pwd length: ${fieldsToValidate.length}');
    }

    state = state.copyWith(
      status: FormStatus.posting,
      email: Email.dirty(state.email.value),
      name: GenericText.dirty(state.name.value),
      surname: GenericText.dirty(state.surname.value),
      password: PasswordText.dirty(state.password.value),
      repeatPassword: PasswordText.dirty(state.repeatPassword.value),
    );

    if (state.password != state.repeatPassword) {
      if (onPasswordMismatch == null) return;
      onPasswordMismatch();
      return;
    }

    if (!state.isValid) return;

    onSubmit();
  }

  void nameChanged(String value) {
    final name = GenericText.dirty(value);
    _updateField(name, (val) => state.copyWith(name: val));
  }

  void surnameChanged(String value) {
    final surname = GenericText.dirty(value);
    _updateField(surname, (val) => state.copyWith(surname: val));
  }

  void usernameChanged(String value) {
    final name = GenericText.dirty(value);
    _updateField(name, (val) => state.copyWith(username: val));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    _updateField(email, (val) => state.copyWith(email: val));
  }

  void passwordChanged(String value) {
    final password = PasswordText.dirty(value);
    _updateField(password, (val) => state.copyWith(password: val));
  }

  void repeatPasswordChanged(String value) {
    final repeat = PasswordText.dirty(value);
    _updateField(repeat, (val) => state.copyWith(repeatPassword: val));
  }

  void _updateField<T extends FormzInput>(
    T value,
    SignupFormState Function(T value) update,
  ) {
    state = update(value);
    _validateForm();
  }

  void _validateForm() {
    List<FormzInput> fields = [
      state.name,
      state.surname,
      state.email,
      state.password,
      state.repeatPassword,
      state.username,
      state.city,
      state.country,
    ];

    final isValid =
        Formz.validate(fields) && state.password == state.repeatPassword;

    state = state.copyWith(isValid: isValid);
  }

  void clearFormState() {
    state = state.copyWith(
      email: const Email.pure(),
      name: const GenericText.pure(),
      surname: const GenericText.pure(),
      password: const PasswordText.pure(),
      repeatPassword: const PasswordText.pure(),
      username: GenericText.pure(),
    );
  }

  void _dispose() {
    state.nameController?.dispose();
    state.surnameController?.dispose();
    state.emailController?.dispose();
    state.passwordController?.dispose();
    state.repeatPasswordController?.dispose();
    state.usernameController?.dispose();
    state.countryController?.dispose();
    state.cityController?.dispose();
  }
}
