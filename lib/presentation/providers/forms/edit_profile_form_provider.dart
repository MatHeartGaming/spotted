import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:spotted/config/constants/app_constants.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/edit_profile_form_state.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

final editProfileFormProvider = StateNotifierProvider.autoDispose<
  EditProfileNotifierNotifier,
  EditProfileFormState
>((ref) {
  final signupNotifier = EditProfileNotifierNotifier();
  return signupNotifier;
});

class EditProfileNotifierNotifier extends StateNotifier<EditProfileFormState> {
  /// We debounce input so that we don't hammer the repo on every keystroke.
  Timer? _debounceFeatures;
  Timer? _debounceInterests;

  EditProfileNotifierNotifier()
    : super(
        EditProfileFormState(
          nameController: TextEditingController(),
          surnameController: TextEditingController(),
          emailController: TextEditingController(),
          usernameController: TextEditingController(),
          cityController: TextEditingController(),
          featureController: TextEditingController(),
          interestsController: TextEditingController(),
          countryController: MultiSelectController<String>(),
        ),
      );

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void initFormField(UserModel user) {
    state.nameController?.text = user.name;
    state.surnameController?.text = user.surname;
    state.emailController?.text = user.email;
    state.usernameController?.text = user.username;
    state.countryController?.selectWhere((item) => item.value == user.country);
    state.cityController?.text = user.city;
    state = state.copyWith(
      nameController: state.nameController,
      surnameController: state.surnameController,
      emailController: state.emailController,
      usernameController: state.usernameController,
      cityController: state.cityController,
      countryController: state.countryController,
      name: GenericText.dirty(user.name),
      surname: GenericText.dirty(user.surname),
      username: GenericText.dirty(user.username),
      city: GenericText.dirty(user.city),
      country: GenericText.dirty(user.country),
      email: Email.dirty(user.email),
      status: FormStatus.invalid,
      isValid: false,
    );
  }

  void initCountryDropDownMenu() {
    state.countryController?.selectWhere((item) => item.value == "Italy");
    state = state.copyWith(country: GenericText.dirty("Italy"));
  }

  void onSubmit({required VoidCallback onSubmit}) {
    List<FormzInput> fieldsToValidate = [
      state.email,
      state.name,
      state.surname,
      state.username,
      state.city,
      state.country,
    ];

    state = state.copyWith(
      status: FormStatus.posting,
      email: Email.dirty(state.email.value),
      name: GenericText.dirty(state.name.value),
      surname: GenericText.dirty(state.surname.value),
      city: GenericText.dirty(state.city.value),
      country: GenericText.dirty(state.country.value),
      username: GenericText.dirty(state.username.value),
      isValid: Formz.validate(fieldsToValidate),
    );

    if (!state.isValid) {
      resetFormStatus();
      return;
    }

    onSubmit();
  }

  void resetFormStatus({FormStatus status = FormStatus.invalid}) {
    state = state.copyWith(status: status);
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
    final username = GenericText.dirty(value);
    _updateField(username, (val) => state.copyWith(username: val));
  }

  void cityChanged(String value) {
    final city = GenericText.dirty(value);
    _updateField(city, (val) => state.copyWith(city: val));
  }

  void countryChanged(String value) {
    final country = GenericText.dirty(value);
    _updateField(country, (val) => state.copyWith(country: val));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    _updateField(email, (val) => state.copyWith(email: val));
  }

  void _updateField<T extends FormzInput>(
    T value,
    EditProfileFormState Function(T value) update,
  ) {
    state = update(value);
    _validateForm();
  }

  void onProfilePicBytesChanged(Uint8List bytes) {
    state = state.copyWith(profileImageBytes: bytes);
  }

  void onProfilePicFileChanged(XFile file) {
    state = state.copyWith(profileImageFile: file);
  }

  void _validateForm() {
    List<FormzInput> fields = [
      state.name,
      state.surname,
      state.email,
      state.username,
      state.city,
      state.country,
    ];

    final isValid = Formz.validate(fields);

    state = state.copyWith(isValid: isValid);
  }

  void onFeatureSearchChanged(String value, Function(String) onSearch) {
    if (_debounceFeatures?.isActive ?? false) _debounceFeatures!.cancel();
    _debounceFeatures = Timer(const Duration(milliseconds: 300), () {
      logger.i('Start feature search: $value');
      onSearch(value);
    });
  }

  void onInterstsSearchChanged(String value, Function(String) onSearch) {
    if (_debounceInterests?.isActive ?? false) _debounceInterests!.cancel();
    _debounceInterests = Timer(const Duration(milliseconds: 300), () {
      logger.i('Start interest search: $value');
      onSearch(value);
    });
  }

  void clearFormState() {
    state.cityController?.clear();
    state.emailController?.clear();
    state.nameController?.clear();
    state.surnameController?.clear();
    state.usernameController?.clear();
    state.featureController?.clear();
    state.interestsController?.clear();

    state = state.copyWith(
      email: const Email.pure(),
      name: const GenericText.pure(),
      surname: const GenericText.pure(),
      username: GenericText.pure(),
      city: const GenericText.pure(),
      country: const GenericText.pure(),
      features: [],
      interests: [],
    );
  }

  void _dispose() {
    state.nameController?.dispose();
    state.surnameController?.dispose();
    state.emailController?.dispose();
    state.usernameController?.dispose();
    state.countryController?.dispose();
    state.cityController?.dispose();
    state.featureController?.dispose();
    state.interestsController?.dispose();
    _debounceFeatures?.cancel();
    _debounceInterests?.cancel();
  }
}
