import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class CommentsDatasourceMockImpl implements CommentsDatasource {
  @override
  Future<Comment?> createComment(Comment comment) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockComments.add(comment);
      return comment;
    });
  }

  @override
  Future<Comment?> updateComment(Comment comment) async {
    final rng = Random();
    final randomTime = rng.nextInt(300);

    return await Future.delayed(Duration(milliseconds: randomTime), () {
      // find index of existing user
      final idx = mockComments.indexWhere((c) => c.id == comment.id);
      if (idx != -1) {
        // replace the old user
        mockComments[idx] = comment;
        return comment;
      }
      // not found: nothing to update
      return null;
    });
  }

  @override
  Future<List<Comment>> getCommentsByPostId(String postId) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockComments.where((c) => c.id == postId).toList(),
    );
  }

  @override
  Future<List<Comment>> getCommentsByPostedInCommunity(String postedIn) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockComments
              .where(
                (c) =>
                    (c.postedIn ?? '').toLowerCase().trim().contains(postedIn),
              )
              .toList(),
    );
  }

  @override
  Future<List<Comment>> getCommentById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockComments
              .where((c) => c.id.toLowerCase().trim().contains(id))
              .toList(),
    );
  }

  @override
  Future<List<Comment>> getCommentsByCreatedById(String createdById) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockComments
              .where(
                (c) => c.createdById.toLowerCase().trim().contains(createdById),
              )
              .toList(),
    );
  }

  @override
  Future<List<Comment>> getCommentsByCreatedByUsername(
    String createdByUsername,
  ) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockComments
              .where(
                (c) => c.createdByUsername.toLowerCase().trim().contains(
                  createdByUsername,
                ),
              )
              .toList(),
    );
  }

  @override
  Future<List<Comment>> deleteCommentById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockComments.removeWhere((c) => c.id == id);
      return mockComments;
    });
  }
}
