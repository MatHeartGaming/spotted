// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:spotted/infrastructure/input_validations/inputs.dart';
import 'package:spotted/presentation/providers/forms/states/form_status.dart';

class CommentsFormState {
  final bool isValid;
  final FormStatus status;
  final GenericText comment;

  // Controllers
  final TextEditingController? commentController;

  CommentsFormState({
    this.comment = const GenericText.pure(),
    this.commentController,
    this.isValid = false,
    this.status = FormStatus.invalid,
  });

  bool get isPosting => status == FormStatus.posting;

  @override
  bool operator ==(covariant CommentsFormState other) {
    if (identical(this, other)) return true;

    return other.isValid == isValid &&
        other.status == status &&
        other.comment == comment &&
        other.commentController == commentController;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        status.hashCode ^
        comment.hashCode ^
        commentController.hashCode;
  }

  CommentsFormState copyWith({
    bool? isValid,
    FormStatus? status,
    GenericText? comment,
    TextEditingController? commentController,
  }) {
    return CommentsFormState(
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      commentController: commentController ?? this.commentController,
    );
  }
}
