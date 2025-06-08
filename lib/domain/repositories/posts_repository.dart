import 'package:spotted/domain/models/models.dart';

abstract class PostsRepository {
  Future<List<Post>> getAllPosts();
  Future<List<Post>> getPostsById(String id);
  Future<Post?> getPostById(String id);
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
  Future<List<Post>> getPostsUsingUsersPostedIdList(List<String> refs);
  Future<List<Post>> deletePostById(String postedIn);
  Future<bool> addComment(String postId, String commentId);
  Future<bool> addReaction(String postId, String userId, String reaction);
  Future<bool> removeComment(String postId, String commentId);
  Future<bool> removeReaction(String postId, String userId);
}
