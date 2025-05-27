// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spotted/infrastructure/input_validations/generic_text_input.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

class CreatePostFormState {
  final FormStatus status;
  final bool isValid;
  final GenericText title;
  final GenericText? postedIn;
  final GenericText content;
  final List<Uint8List>? imagesBytes;
  final List<XFile>? imagesFile;
  final List<String>? imagesUrl;

  // Controllers
  final TextEditingController? titleController;
  final TextEditingController? contentController;

  CreatePostFormState({
    this.status = FormStatus.invalid,
    this.isValid = false,
    this.title = const GenericText.pure(),
    this.content = const GenericText.pure(),
    this.postedIn,
    this.imagesBytes = const [],
    this.imagesFile = const [],
    this.imagesUrl = const [],
    this.titleController,
    this.contentController,
  });

  bool get isPosting => status == FormStatus.posting;

  @override
  bool operator ==(covariant CreatePostFormState other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      other.isValid == isValid &&
      other.title == title &&
      other.postedIn == postedIn &&
      other.content == content &&
      listEquals(other.imagesBytes, imagesBytes) &&
      listEquals(other.imagesFile, imagesFile) &&
      listEquals(other.imagesUrl, imagesUrl) &&
      other.titleController == titleController &&
      other.contentController == contentController;
  }

  @override
  int get hashCode {
    return status.hashCode ^
      isValid.hashCode ^
      title.hashCode ^
      postedIn.hashCode ^
      content.hashCode ^
      imagesBytes.hashCode ^
      imagesFile.hashCode ^
      imagesUrl.hashCode ^
      titleController.hashCode ^
      contentController.hashCode;
  }

  CreatePostFormState copyWith({
    FormStatus? status,
    bool? isValid,
    GenericText? title,
    GenericText? postedIn,
    GenericText? content,
    List<Uint8List>? imagesBytes,
    List<XFile>? imagesFile,
    List<String>? imagesUrl,
    TextEditingController? titleController,
    TextEditingController? contentController,
  }) {
    return CreatePostFormState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      title: title ?? this.title,
      postedIn: postedIn ?? this.postedIn,
      content: content ?? this.content,
      imagesBytes: imagesBytes ?? this.imagesBytes,
      imagesFile: imagesFile ?? this.imagesFile,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      titleController: titleController ?? this.titleController,
      contentController: contentController ?? this.contentController,
    );
  }
}
