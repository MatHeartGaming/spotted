// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

class EditProfileFormState {
  final FormStatus status;
  final bool isValid;
  final Email email;
  final GenericText name;
  final GenericText surname;
  final GenericText username;
  final GenericText country;
  final GenericText city;
  final List<String> interests;
  final List<String> features;
  final Uint8List? profileImageBytes;
  final XFile? profileImageFile;

  /// Controllers
  final TextEditingController? emailController;
  final TextEditingController? nameController;
  final TextEditingController? surnameController;
  final TextEditingController? usernameController;
  final TextEditingController? cityController;
  final TextEditingController? featureController;
  final TextEditingController? interestsController;
  final MultiSelectController<String>? countryController;

  const EditProfileFormState({
    this.status = FormStatus.invalid,
    this.isValid = false,
    this.email = const Email.pure(),
    this.name = const GenericText.pure(),
    this.surname = const GenericText.pure(),
    this.username = const GenericText.pure(),
    this.country = const GenericText.pure(),
    this.city = const GenericText.pure(),
    this.features = const [],
    this.interests = const [],
    this.profileImageBytes,
    this.profileImageFile,
    this.emailController,
    this.nameController,
    this.surnameController,
    this.usernameController,
    this.countryController,
    this.cityController,
    this.featureController,
    this.interestsController,
  });

  EditProfileFormState copyWith({
    FormStatus? status,
    bool? isValid,
    Email? email,
    GenericText? name,
    GenericText? surname,
    GenericText? username,
    GenericText? country,
    GenericText? city,
    List<String>? interests,
    List<String>? features,
    Uint8List? profileImageBytes,
    XFile? profileImageFile,
    TextEditingController? emailController,
    TextEditingController? nameController,
    TextEditingController? surnameController,
    TextEditingController? usernameController,
    MultiSelectController<String>? countryController,
    TextEditingController? cityController,
    TextEditingController? featureController,
    TextEditingController? interestsController,
  }) => EditProfileFormState(
    status: status ?? this.status,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    name: name ?? this.name,
    surname: surname ?? this.surname,
    username: username ?? this.username,
    country: country ?? this.country,
    city: city ?? this.city,
    profileImageBytes: profileImageBytes ?? this.profileImageBytes,
    profileImageFile: profileImageFile ?? this.profileImageFile,
    interests: interests ?? this.interests,
    features: features ?? this.features,
    emailController: emailController ?? this.emailController,
    nameController: nameController ?? this.nameController,
    surnameController: surnameController ?? this.surnameController,
    usernameController: usernameController ?? this.usernameController,
    countryController: countryController ?? this.countryController,
    cityController: cityController ?? this.cityController,
    featureController: featureController ?? this.featureController,
    interestsController: interestsController ?? this.interestsController,
  );

  bool get isPosting => status == FormStatus.posting;
}
