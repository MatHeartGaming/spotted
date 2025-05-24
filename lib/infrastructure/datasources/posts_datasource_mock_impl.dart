import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class PostsDatasourceMockImpl implements PostsDatasource {
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
  Future<List<Post>> getAllPostsByCreatedById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockPosts.where((p) => p.createdById == id).toList(),
    );
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
  Future<List<Post>> getPostById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockPosts.where((p) => p.id == id).toList(),
    );
  }
}
