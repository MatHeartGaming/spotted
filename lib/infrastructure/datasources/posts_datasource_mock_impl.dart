import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class PostsDatasourceMockImpl implements PostsDatasource {
  @override
  Future<Post?> createPost(Post post) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockPosts.add(post);
      return post;
    });
  }

  @override
  Future<Post?> updatePost(Post post) async {
    final rng = Random();
    final randomTime = rng.nextInt(300);

    return await Future.delayed(Duration(milliseconds: randomTime), () {
      // find index of existing user
      final idx = mockPosts.indexWhere((p) => p.id == post.id);
      if (idx != -1) {
        // replace the old user
        mockPosts[idx] = post;
        return post;
      }
      // not found: nothing to update
      return null;
    });
  }

  @override
  Future<List<Post>> getAllPosts() async {
    var rng = Random();
    int randomTime = rng.nextInt(500);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockPosts,
    );
  }

  @override
  Future<List<Post>> getAllPostsByContent(String content) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockPosts
              .where(
                (p) => p.content.toLowerCase().trim().contains(
                  content.toLowerCase().trim(),
                ),
              )
              .toList(),
    );
  }

  @override
  Future<List<Post>> getPostsUsingPostedInList(List<String> refs) async {
    List<Future<List<Post>>> futures = [];

    for (String r in refs) {
      Future<List<Post>> future = getAllPostsByPostedIn(r);
      futures.add(future);
    }
    List<List<Post>> listOfLists = await Future.wait(futures);
    List<Post> allPosts = listOfLists.expand((posts) => posts).toList();
    return allPosts;
  }

  @override
  Future<List<Post>> getAllPostsByPostedIn(String postedIn) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockPosts.where((p) => p.postedIn == postedIn).toList(),
    );
  }

  @override
  Future<List<Post>> getPostsUsingUsersIdListRef(List<String> refs) async {
    List<Future<List<Post>>> futures = [];

    for (String r in refs) {
      Future<List<Post>> future = getAllPostsByCreatedById(r);
      futures.add(future);
    }
    List<List<Post>> listOfLists = await Future.wait(futures);
    List<Post> allPosts = listOfLists.expand((posts) => posts).toList();
    return allPosts;
  }

  @override
  Future<List<Post>> getAllPostsByCreatedById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockPosts.where((p) => p.createdById == id).toList(),
    );
  }

  @override
  Future<List<Post>> getPostsUsingUsernamesList(List<String> refs) async {
    List<Future<List<Post>>> futures = [];

    for (String r in refs) {
      Future<List<Post>> future = getAllPostsByCreatedByUsername(r);
      futures.add(future);
    }
    List<List<Post>> listOfLists = await Future.wait(futures);
    List<Post> allPosts = listOfLists.expand((posts) => posts).toList();
    return allPosts;
  }

  @override
  Future<List<Post>> getAllPostsByCreatedByUsername(String username) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockPosts
              .where(
                (p) => p.createdByUsername.toLowerCase().trim().contains(
                  username.toLowerCase().trim(),
                ),
              )
              .toList(),
    );
  }

  @override
  Future<List<Post>> getAllPostsByTitle(String title) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockPosts
              .where(
                (p) => p.title.toLowerCase().trim().contains(
                  title.toLowerCase().trim(),
                ),
              )
              .toList(),
    );
  }

  @override
  Future<List<Post>> getPostsUsingUsersPostedIdList(List<String> refs) async {
    List<Future<Post?>> futures = [];

    for (String r in refs) {
      Future<Post?> future = getPostById(r);
      futures.add(future);
    }
    List<Post?> list = await Future.wait(futures);
    List<Post> nonNullPosts = [];
    for (Post? c in list) {
      if (c != null) {
        nonNullPosts.add(c);
      }
    }
    return nonNullPosts;
  }

  @override
  Future<List<Post>> getPostsById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockPosts.where((p) => p.id == id).toList(),
    );
  }

  @override
  Future<Post?> getPostById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      final posts = mockPosts.where((p) => p.id == id).toList();
      if (posts.isNotEmpty) return posts.first;
      return null;
    });
  }

  @override
  Future<List<Post>> deletePostById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockPosts.removeWhere((p) => p.id == id);
      return mockPosts;
    });
  }
  
  @override
  Future<bool> addComment(String postId, String commentId) {
    // TODO: implement addComment
    throw UnimplementedError();
  }
  
  @override
  Future<bool> addReaction(String postId, String userId, String reaction) {
    // TODO: implement addReaction
    throw UnimplementedError();
  }
  
  @override
  Future<bool> removeComment(String postId, String commentId) {
    // TODO: implement removeComment
    throw UnimplementedError();
  }
  
  @override
  Future<bool> removeReaction(String postId, String userId) {
    // TODO: implement removeReaction
    throw UnimplementedError();
  }
}
