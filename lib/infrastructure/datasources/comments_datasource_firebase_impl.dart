import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/comment.dart';

class CommentsDatasourceFirebaseImpl implements CommentsDatasource {
  @override
  Future<List<Comment>> getCommentById(String id) {
    // TODO: implement getCommentById
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> getCommentsByCreatedById(String createdById) {
    // TODO: implement getCommentsByCreatedById
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> getCommentsByCreatedByUsername(String createdByUsername) {
    // TODO: implement getCommentsByCreatedByUsername
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> getCommentsByPostId(String postId) {
    // TODO: implement getCommentsByPostId
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> getCommentsByPostedInCommunity(String postedIn) {
    // TODO: implement getCommentsByPostedInCommunity
    throw UnimplementedError();
  }

}