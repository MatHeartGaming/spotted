import 'package:spotted/domain/models/models.dart';

abstract class CommentsRepository {
  Future<List<Comment>> getCommentsByPostId(String postId);
  Future<List<Comment>> getCommentsByPostedInCommunity(String postedIn);
  Future<List<Comment>> getCommentById(String id);
  Future<List<Comment>> getCommentsByCreatedById(String createdById);
  Future<List<Comment>> getCommentsByCreatedByUsername(
    String createdByUsername,
  );
  Future<Comment?> createComment(Comment comment);
  Future<Comment?> updateComment(Comment comment);
  Future<List<Comment>> deleteCommentById(String id);
}
