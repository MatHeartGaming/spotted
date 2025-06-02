import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:spotted/infrastructure/input_validations/generic_text_input.dart';
import 'package:spotted/presentation/providers/forms/states/comments_form_state.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

final commentsFormProvider = StateNotifierProvider.autoDispose<
  CommenentsFormNotifier,
  CommentsFormState
>((ref) {
  final commentsNotifier = CommenentsFormNotifier();
  return commentsNotifier;
});

class CommenentsFormNotifier extends StateNotifier<CommentsFormState> {
  CommenentsFormNotifier()
    : super(CommentsFormState(commentController: TextEditingController()));

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void onSumbit({required VoidCallback onSubmit}) {
    validateFields(status: FormStatus.posting);
    if (!state.isValid) {
      resetFormStatus();
      return;
    }

    onSubmit();
  }

  void validateFields({FormStatus status = FormStatus.invalid}) {
    state = state.copyWith(
      status: status,
      isValid: Formz.validate([state.comment]),
    );
  }

  void resetFormStatus({FormStatus status = FormStatus.invalid}) {
    state = state.copyWith(status: status);
  }

  void onCommentChange(String newValue) {
    final newComment = GenericText.dirty(newValue);
    state = state.copyWith(
      comment: newComment,
      isValid: Formz.validate([newComment]),
    );
  }

  void clearComment() {
    state.commentController?.clear();
    state = state.copyWith(
      comment: GenericText.pure(),
      commentController: state.commentController,
    );
  }

  void _dispose() {
    state.commentController?.dispose();
    state = state.copyWith(
      comment: GenericText.pure(),
      commentController: null,
      isValid: false,
      status: FormStatus.invalid,
    );
  }

  // ignore: unused_element
  void _clear() {
    state.commentController?.clear();
    state = state.copyWith(
      comment: GenericText.pure(),
      commentController: state.commentController,
      isValid: false,
      status: FormStatus.invalid,
    );
  }
}
