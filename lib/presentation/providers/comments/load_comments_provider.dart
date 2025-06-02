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

  Future<List<Comment>> createComment(Comment comment) async {
    if (state.isLoadingComments) return state.comments;
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

    return state.comments;
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
