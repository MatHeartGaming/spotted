import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/post.dart';

class PostsDatasourceFirebaseImpl implements PostsDatasource {
  @override
  Future<List<Post>> getAllPosts() {
    // TODO: implement getAllPosts
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAllPostsByContent(String content) {
    // TODO: implement getAllPostsByContent
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAllPostsByCreatedById(String id) {
    // TODO: implement getAllPostsByCreatedById
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAllPostsByCreatedByUsername(String username) {
    // TODO: implement getAllPostsByCreatedByUsername
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAllPostsByTitle(String title) {
    // TODO: implement getAllPostsByTitle
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPostById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

}