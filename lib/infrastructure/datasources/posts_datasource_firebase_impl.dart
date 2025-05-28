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
  Future<List<Post>> getPostsById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }
  
  @override
  Future<List<Post>> getPostsUsingUsernamesList(List<String> refs) {
    // TODO: implement getPostsUsingUsernamesListRef
    throw UnimplementedError();
  }
  
  @override
  Future<List<Post>> getPostsUsingUsersIdListRef(List<String> refs) {
    // TODO: implement getPostsUsingUsersIdListRef
    throw UnimplementedError();
  }
  
  @override
  Future<List<Post>> getAllPostsByPostedIn(String postedIn) {
    // TODO: implement getAllPostsByPostedIn
    throw UnimplementedError();
  }
  
  @override
  Future<List<Post>> getPostsUsingPostedInList(List<String> refs) {
    // TODO: implement getPostsUsingPostedInList
    throw UnimplementedError();
  }
  
  @override
  Future<Post?> createPost(Post post) {
    // TODO: implement createPost
    throw UnimplementedError();
  }
  
  @override
  Future<Post?> updatePost(Post post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
  
  @override
  Future<Post?> getPostById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }
  
  @override
  Future<List<Post>> getPostsUsingUsersPostedIdList(List<String> refs) {
    // TODO: implement getPostsUsingUsersPostedIdList
    throw UnimplementedError();
  }

}