import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';

class CommentsDatasourceMockImpl implements CommentsDatasource {
  
  @override
  Future<List<Comment>> getCommentsByPostId(String postId) async {
    return [];
  }

  @override
  Future<List<Comment>> getCommentsByPostedInCommunity(String postedIn) async {
    return [];
  }

  @override
  Future<List<Comment>> getCommentById(String id) async {
    return [];
  }

  @override
  Future<List<Comment>> getCommentsByCreatedById(String createdById) async {
    return [];
  }

  @override
  Future<List<Comment>> getCommentsByCreatedByUsername(String createdByUsername) async {
    return [];
  }
}
