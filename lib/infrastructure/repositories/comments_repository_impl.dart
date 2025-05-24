import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/comment.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/comments_datasource_mock_impl.dart';

class CommentsRepositoryImplementation implements CommentsRepository {
  final CommentsDatasource _db;

  CommentsRepositoryImplementation([CommentsDatasource? db])
    : _db = db ?? CommentsDatasourceMockImpl();

  @override
  Future<List<Comment>> getCommentById(String id) {
    return _db.getCommentById(id);
  }

  @override
  Future<List<Comment>> getCommentsByCreatedById(String createdById) {
    return _db.getCommentsByCreatedById(createdById);
  }

  @override
  Future<List<Comment>> getCommentsByCreatedByUsername(
    String createdByUsername,
  ) {
    return _db.getCommentsByCreatedByUsername(createdByUsername);
  }

  @override
  Future<List<Comment>> getCommentsByPostId(String postId) {
    return _db.getCommentsByPostId(postId);
  }

  @override
  Future<List<Comment>> getCommentsByPostedInCommunity(String postedIn) {
    return _db.getCommentsByPostedInCommunity(postedIn);
  }

  @override
  Future<Comment?> createComment(Comment comment) {
    return _db.createComment(comment);
  }

  @override
  Future<Comment?> updateComment(Comment comment) {
    return _db.updateComment(comment);
  }
}
