import 'package:spotted/domain/models/models.dart';

abstract class PostsDatasource {
  Future<List<Post>> getAllPosts();
  Future<List<Post>> getPostById(String id);
  Future<List<Post>> getAllPostsByCreatedById(String id);
  Future<List<Post>> getAllPostsByCreatedByUsername(String username);
  Future<List<Post>> getAllPostsByTitle(String title);
  Future<List<Post>> getAllPostsByContent(String content);
  Future<List<Post>> getPostsUsingUsersIdListRef(List<String> refs);
  Future<List<Post>> getPostsUsingUsernamesList(List<String> refs);
  Future<List<Post>> getAllPostsByPostedIn(String postedIn);
  Future<List<Post>> getPostsUsingPostedInList(List<String> refs);
  Future<Post?> createPost(Post post);
  Future<Post?> updatePost(Post post);
}
