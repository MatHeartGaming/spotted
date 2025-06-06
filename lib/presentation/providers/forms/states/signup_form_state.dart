// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

class SignupFormState {
  final FormStatus status;
  final bool isValid;
  final Email email;
  final PasswordText password;
  final PasswordText repeatPassword;
  final GenericText name;
  final GenericText surname;
  final GenericText username;
  final GenericText country;
  final GenericText city;
  final List<String> features;
  final List<String> selectedFeatures;
  final List<String> interests;

  /// Controllers
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? repeatPasswordController;
  final TextEditingController? nameController;
  final TextEditingController? surnameController;
  final TextEditingController? usernameController;
  final TextEditingController? cityController;
  final MultiSelectController<String>? countryController;
  final MultiSelectController<String>? featuresController;
  final MultiSelectController<String>? interestsController;

  const SignupFormState({
    this.status = FormStatus.invalid,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const PasswordText.pure(),
    this.repeatPassword = const PasswordText.pure(),
    this.name = const GenericText.pure(),
    this.surname = const GenericText.pure(),
    this.username = const GenericText.pure(),
    this.country = const GenericText.pure(),
    this.city = const GenericText.pure(),
    this.features = const [],
    this.selectedFeatures = const [],
    this.interests = const [],
    this.emailController,
    this.passwordController,
    this.repeatPasswordController,
    this.nameController,
    this.surnameController,
    this.usernameController,
    this.countryController,
    this.cityController,
    this.featuresController,
    this.interestsController,
  });

  SignupFormState copyWith({
    FormStatus? status,
    bool? isValid,
    Email? email,
    PasswordText? password,
    PasswordText? repeatPassword,
    GenericText? name,
    GenericText? surname,
    GenericText? username,
    GenericText? country,
    GenericText? city,
    List<String>? features,
    List<String>? selectedFeatures,
    List<String>? interests,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? repeatPasswordController,
    TextEditingController? nameController,
    TextEditingController? surnameController,
    TextEditingController? usernameController,
    MultiSelectController<String>? countryController,
    MultiSelectController<String>? featuresController,
    MultiSelectController<String>? interestsController,
    TextEditingController? cityController,
  }) => SignupFormState(
    status: status ?? this.status,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    name: name ?? this.name,
    surname: surname ?? this.surname,
    username: username ?? this.username,
    country: country ?? this.country,
    city: city ?? this.city,
    features: features ?? this.features,
    selectedFeatures: selectedFeatures ?? this.selectedFeatures,
    interests: interests ?? this.interests,
    password: password ?? this.password,
    repeatPassword: repeatPassword ?? this.repeatPassword,
    emailController: emailController ?? this.emailController,
    passwordController: passwordController ?? this.passwordController,
    repeatPasswordController:
        repeatPasswordController ?? this.repeatPasswordController,
    nameController: nameController ?? this.nameController,
    surnameController: surnameController ?? this.surnameController,
    usernameController: usernameController ?? this.usernameController,
    countryController: countryController ?? this.countryController,
    cityController: cityController ?? this.cityController,
    featuresController: featuresController ?? this.featuresController,
    interestsController: interestsController ?? this.interestsController,
  );

  bool get isPosting => status == FormStatus.posting;

  @override
  bool operator ==(covariant SignupFormState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.isValid == isValid &&
        other.email == email &&
        other.password == password &&
        other.repeatPassword == repeatPassword &&
        other.name == name &&
        other.username == username &&
        other.country == country &&
        other.city == city &&
        other.features == features &&
        other.interests == interests &&
        other.surname == surname;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        isValid.hashCode ^
        email.hashCode ^
        password.hashCode ^
        repeatPassword.hashCode ^
        name.hashCode ^
        username.hashCode ^
        surname.hashCode ^
        country.hashCode ^
        features.hashCode ^
        interests.hashCode ^
        city.hashCode;
  }
}
