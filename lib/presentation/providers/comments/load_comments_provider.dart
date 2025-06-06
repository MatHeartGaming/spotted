// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/repositories/comments_repository.dart';
import 'package:spotted/presentation/providers/comments/comments_repository_provider.dart';

import '../../../domain/models/models.dart';

final loadCommentsProvider =
    StateNotifierProvider.autoDispose<LoadCommentsNotifier, LoadCommentsState>((
      ref,
    ) {
      final commentsRepo = ref.watch(commentsRepositoryProvider);
      final notifier = LoadCommentsNotifier(commentsRepo);
      return notifier;
    });

class LoadCommentsNotifier extends StateNotifier<LoadCommentsState> {
  final CommentsRepository _commentsRepository;

  LoadCommentsNotifier(this._commentsRepository) : super(LoadCommentsState());

  Future<List<Comment>> loadComments(String postId) async {
    if (state.isLoadingComments) return state.comments;
    state = state.copyWith(isLoadingComments: true);

    final comments = await _commentsRepository.getCommentsByPostId(postId);

    state = state.copyWith(isLoadingComments: false, comments: comments);

    logger.d('Commenti: $comments');

    return comments;
  }

  Future<(List<Comment>, Comment)> createComment(Comment comment) async {
    if (state.isLoadingComments) return (state.comments, comment);
    state = state.copyWith(isLoadingComments: true);

    final newComment = await _commentsRepository.createComment(comment);

    if (newComment == null) {
      throw Exception('An error occurred while creating the comment $comment');
    }

    state = state.copyWith(
      isLoadingComments: false,
      comments: [...state.comments, comment],
    );

    logger.d('Commenti: $comment');

    return (state.comments, newComment);
  }

  Future<void> updateComment(Comment updatedComment) async {
    if (state.isLoadingComments) return;
    state = state.copyWith(isLoadingComments: true);

    final result = await _commentsRepository.updateComment(updatedComment);
    if (result != null) {
      // We assume `updateComment` sends back the single updated Comment—or maybe null?
      // If your repo just returns the updated Comment, manually replace it in state.comments:
      final idx = state.comments.indexWhere((c) => c.id == updatedComment.id);
      if (idx != -1) {
        final newList = List<Comment>.from(state.comments);
        newList[idx] = updatedComment;
        state = state.copyWith(isLoadingComments: false, comments: newList);
      } else {
        // Fallback: reload all
        final fresh = await _commentsRepository.getCommentsByPostId(
          state.comments.first.postId,
        );
        state = state.copyWith(isLoadingComments: false, comments: fresh);
      }
    } else {
      // Handle “null” or error…
      state = state.copyWith(isLoadingComments: false);
      // Optionally show a SnackBar or throw.
    }
  }

  Future<void> deleteComment(String commentId) async {
    // Set some loading flag if you want; here we’ll just block multiple deletes at once:
    if (state.isLoadingComments) return;

    state = state.copyWith(isLoadingComments: true);

    // Call the repository
    await _commentsRepository.deleteCommentById(commentId);

    // If your repository returns null on error, you could guard here.
    // But since your signature is Future<List<Comment>>, we assume it returns the new list.
    state = state.copyWith(
      isLoadingComments: false,
      comments: state.comments.where((c) => c.id != commentId).toList(),
    );
    logger.i('Comments after deletion: ${state.comments}');
  }
}

class LoadCommentsState {
  final List<Comment> comments;
  final bool isLoadingComments;

  LoadCommentsState({this.comments = const [], this.isLoadingComments = false});

  @override
  bool operator ==(covariant LoadCommentsState other) {
    if (identical(this, other)) return true;

    return listEquals(other.comments, comments) &&
        other.isLoadingComments == isLoadingComments;
  }

  @override
  int get hashCode => comments.hashCode ^ isLoadingComments.hashCode;

  LoadCommentsState copyWith({
    List<Comment>? comments,
    bool? isLoadingComments,
  }) {
    return LoadCommentsState(
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
    );
  }
}
