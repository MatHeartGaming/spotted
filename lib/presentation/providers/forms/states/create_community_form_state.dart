// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spotted/infrastructure/input_validations/generic_text_input.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

class CreateCommunityFormState {
  final FormStatus status;
  final bool isValid;
  final GenericText title;
  final GenericText description;
  final List<String> adminsRefs;
  final List<Uint8List>? imagesBytes;
  final List<XFile>? imagesFile;
  final List<String>? imagesUrl;

  // Controllers
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;

  CreateCommunityFormState({
    this.status = FormStatus.invalid,
    this.isValid = false,
    this.title = const GenericText.pure(),
    this.description = const GenericText.pure(),
    this.adminsRefs = const [],
    this.imagesBytes = const [],
    this.imagesFile = const [],
    this.imagesUrl = const [],
    this.titleController,
    this.descriptionController,
  });

  bool get isPosting => status == FormStatus.posting;

  

  @override
  bool operator ==(covariant CreateCommunityFormState other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      other.isValid == isValid &&
      other.title == title &&
      other.description == description &&
      listEquals(other.adminsRefs, adminsRefs) &&
      listEquals(other.imagesBytes, imagesBytes) &&
      listEquals(other.imagesFile, imagesFile) &&
      listEquals(other.imagesUrl, imagesUrl) &&
      other.titleController == titleController &&
      other.descriptionController == descriptionController;
  }

  @override
  int get hashCode {
    return status.hashCode ^
      isValid.hashCode ^
      title.hashCode ^
      description.hashCode ^
      adminsRefs.hashCode ^
      imagesBytes.hashCode ^
      imagesFile.hashCode ^
      imagesUrl.hashCode ^
      titleController.hashCode ^
      descriptionController.hashCode;
  }

  CreateCommunityFormState copyWith({
    FormStatus? status,
    bool? isValid,
    GenericText? title,
    GenericText? description,
    List<String>? adminsRefs,
    List<Uint8List>? imagesBytes,
    List<XFile>? imagesFile,
    List<String>? imagesUrl,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
  }) {
    return CreateCommunityFormState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      title: title ?? this.title,
      description: description ?? this.description,
      adminsRefs: adminsRefs ?? this.adminsRefs,
      imagesBytes: imagesBytes ?? this.imagesBytes,
      imagesFile: imagesFile ?? this.imagesFile,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      titleController: titleController ?? this.titleController,
      descriptionController: descriptionController ?? this.descriptionController,
    );
  }
}
