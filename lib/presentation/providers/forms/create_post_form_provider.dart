import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/create_post_form_state.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

final createPostProvider =
    StateNotifierProvider.autoDispose<CreatePostNotifier, CreatePostFormState>((
      ref,
    ) {
      final createPostNotifier = CreatePostNotifier();
      return createPostNotifier;
    });

class CreatePostNotifier extends StateNotifier<CreatePostFormState> {
  CreatePostNotifier()
    : super(
        CreatePostFormState(
          titleController: TextEditingController(),
          contentController: TextEditingController(),
        ),
      );

  @override
  void dispose() {
    clearFormState();
    _disposeControllers();
    super.dispose();
  }

  void onSumbit({required VoidCallback onSubmit}) {
    state = state.copyWith(
      status: FormStatus.posting,
      isValid: Formz.validate([state.title, state.content]),
    );
    if (!state.isValid) return;

    onSubmit();
  }

  void onTitleChanged(String value) {
    final newTitle = GenericText.dirty(value);
    state = state.copyWith(
      title: newTitle,
      isValid: Formz.validate([state.content, newTitle]),
    );
  }

  void onContentChanged(String value) {
    final newContent = GenericText.dirty(value);
    state = state.copyWith(
      content: newContent,
      isValid: Formz.validate([state.title, newContent]),
    );
  }

  void imagesFilesChanged(XFile value) {
    state = state.copyWith(imagesFile: [value, ...?state.imagesFile]);
  }

  void imagesBytesChanged(Uint8List value) {
    state = state.copyWith(imagesBytes: [value, ...?state.imagesBytes]);
  }

  void imagesUrlsChanged(String value) {
    state = state.copyWith(imagesUrl: [value, ...?state.imagesUrl]);
  }

  /// removes the image at [index] from all of files/bytes/urls
  void removeImageAt(int index) {
    // make mutable copies
    final files = List<XFile>.from(state.imagesFile ?? []);
    final bytes = List<Uint8List>.from(state.imagesBytes ?? []);
    final urls = List<String>.from(state.imagesUrl ?? []);

    if (index < 0 || index >= files.length) return;

    files.removeAt(index);
    bytes.removeAt(index);

    // TODO: Check this when urls are enabled!!
    //urls.removeAt(index);

    state = state.copyWith(
      imagesFile: files,
      imagesBytes: bytes,
      imagesUrl: urls,
    );
  }

  void _disposeControllers() {
    state.titleController?.dispose();
    state.contentController?.dispose();
    state = state.copyWith(
      title: const GenericText.pure(),
      content: GenericText.pure(),
      status: FormStatus.invalid,
      titleController: null,
      contentController: null,
      imagesBytes: null,
      imagesFile: null,
      imagesUrl: null,
    );
  }

  void clearFormState() {
    state.titleController?.clear();
    state.contentController?.clear();
    state = state.copyWith(
      title: GenericText.pure(),
      content: GenericText.pure(),
      titleController: state.titleController,
      contentController: state.contentController,
      imagesBytes: [],
      imagesFile: [],
      imagesUrl: [],
    );
  }
}
