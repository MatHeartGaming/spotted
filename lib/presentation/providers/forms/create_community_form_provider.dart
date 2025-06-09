import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/create_community_form_state.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

final createCommunityFormProvder = StateNotifierProvider.autoDispose<
  CreateCommunityNotifier,
  CreateCommunityFormState
>((ref) {
  final createPostNotifier = CreateCommunityNotifier();
  return createPostNotifier;
});

class CreateCommunityNotifier extends StateNotifier<CreateCommunityFormState> {
  CreateCommunityNotifier()
    : super(
        CreateCommunityFormState(
          titleController: TextEditingController(),
          descriptionController: TextEditingController(),
        ),
      );

  @override
  void dispose() {
    clearFormState();
    _disposeControllers();
    super.dispose();
  }

  void initForm(Community community) {
    state.titleController?.text = community.title;
    state.descriptionController?.text = community.description;
    final title = GenericText.dirty(community.title);
    final descr = GenericText.dirty(community.description);
    state = state.copyWith(
      titleController: state.titleController,
      descriptionController: state.descriptionController,
      title: title,
      description: descr,
      imagesUrl: community.pictureUrl != null ? [community.pictureUrl!] : [],
      imagesBytes: [],
      imagesFile: [],
      adminsRefs: community.admins,
      isValid: Formz.validate([title, descr]),
    );
  }

  void onSumbit({required VoidCallback onSubmit}) {
    validateFields(status: FormStatus.posting);
    if (!state.isValid) {
      resetFormStatus();
    }

    onSubmit();
  }

  void validateFields({FormStatus status = FormStatus.invalid}) {
    state = state.copyWith(
      status: status,
      isValid: Formz.validate([state.title, state.description]),
    );
  }

  void resetFormStatus({FormStatus status = FormStatus.invalid}) {
    state = state.copyWith(status: status);
  }

  void onTitleChanged(String value) {
    final newTitle = GenericText.dirty(value);
    state = state.copyWith(
      title: newTitle,
      isValid: Formz.validate([state.description, newTitle]),
    );
  }

  void onDescriptionChanged(String value) {
    final newContent = GenericText.dirty(value);
    state = state.copyWith(
      description: newContent,
      isValid: Formz.validate([state.title, newContent]),
    );
  }

  void onAddAdmin(String newAdminRef) {
    state = state.copyWith(
      adminsRefs: [...state.adminsRefs ?? [], newAdminRef],
    );
  }

  void imagesFilesChanged(XFile value) {
    state = state.copyWith(imagesFile: [...?state.imagesFile, value]);
  }

  void imagesBytesChanged(Uint8List value) {
    state = state.copyWith(imagesBytes: [...?state.imagesBytes, value]);
  }

  void imagesUrlsChanged(String value) {
    state = state.copyWith(imagesUrl: [value, ...?state.imagesUrl, value]);
  }

  /// removes the image at [index] from all of files/bytes/urls
  void removeImageAt(int index) {
    // make mutable copies
    final files = List<XFile>.from(state.imagesFile ?? []);
    final bytes = List<Uint8List>.from(state.imagesBytes ?? []);
    final urls = List<String>.from(state.imagesUrl ?? []);

    if (index < 0) return;

    if (files.isNotEmpty) files.removeAt(index);
    if(bytes.isNotEmpty) bytes.removeAt(index);

    if (urls.isNotEmpty) urls.removeAt(index);

    state = state.copyWith(
      imagesFile: files,
      imagesBytes: bytes,
      imagesUrl: urls,
    );
  }

  void _disposeControllers() {
    state.titleController?.dispose();
    state.descriptionController?.dispose();
    state = state.copyWith(
      title: const GenericText.pure(),
      description: const GenericText.pure(),
      adminsRefs: [],
      imagesUrl: null,
      imagesBytes: null,
      imagesFile: null,
      descriptionController: null,
      titleController: null,
      isValid: false,
      status: FormStatus.invalid,
    );
  }

  void clearFormState() {
    state.titleController?.clear();
    state.descriptionController?.clear();
    state = state.copyWith(
      title: GenericText.pure(),
      description: GenericText.pure(),
      titleController: state.titleController,
      descriptionController: state.descriptionController,
      adminsRefs: [],
      imagesBytes: null,
      imagesFile: null,
      imagesUrl: null,
    );
  }
}
