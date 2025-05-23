import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/post.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';

class PostsRepositoryImplementation implements PostsRepository {
  final PostsDatasource _db;

  PostsRepositoryImplementation([PostsDatasource? db])
    : _db = db ?? PostsDatasourceMockImpl();

  @override
  Future<List<Post>> getAllPosts() {
    return _db.getAllPosts();
  }

  @override
  Future<List<Post>> getAllPostsByContent(String content) {
    return _db.getAllPostsByContent(content);
  }

  @override
  Future<List<Post>> getAllPostsByCreatedById(String id) {
    return _db.getAllPostsByCreatedById(id);
  }

  @override
  Future<List<Post>> getAllPostsByCreatedByUsername(String username) {
    return _db.getAllPostsByCreatedByUsername(username);
  }

  @override
  Future<List<Post>> getAllPostsByTitle(String title) {
    return _db.getAllPostsByTitle(title);
  }

  @override
  Future<List<Post>> getPostById(String id) {
    return _db.getPostById(id);
  }
}
