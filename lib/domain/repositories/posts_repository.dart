import 'package:spotted/domain/models/models.dart';

abstract class PostsRepository {
  Future<List<Post>> getAllPosts();
  Future<List<Post>> getPostById(String id);
  Future<List<Post>> getAllPostsByCreatedById(String id);
  Future<List<Post>> getAllPostsByCreatedByUsername(String username);
  Future<List<Post>> getAllPostsByTitle(String title);
  Future<List<Post>> getAllPostsByContent(String content);
}