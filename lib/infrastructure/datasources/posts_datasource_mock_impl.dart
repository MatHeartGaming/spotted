import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';

class PostsDatasourceMockImpl implements PostsDatasource {
  @override
  Future<List<Post>> getAllPosts() async {
    return [];
  }

  @override
  Future<List<Post>> getPostById(String id) async {
    return [];
  }

  @override
  Future<List<Post>> getAllPostsByCreatedById(String id) async {
    return [];
  }

  @override
  Future<List<Post>> getAllPostsByCreatedByUsername(String username) async {
    return [];
  }

  @override
  Future<List<Post>> getAllPostsByTitle(String title) async {
    return [];
  }

  @override
  Future<List<Post>> getAllPostsByContent(String content) async {
    return [];
  }
}
