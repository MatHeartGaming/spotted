import 'package:spotted/domain/models/models.dart';

abstract class CommunityDatasource {
  Future<List<Community>> getAllCommunities();
  Future<List<Community>> getCommunitiesByTitle(String title);
  Future<Community?> getCommunityByTitle(String title);
  Future<List<Community>> getCommunitiesByCreatedBy(String createdById);
  Future<List<Community>> getCommunitiesByCreatedUsername(
    String createdByUsername,
  );
  Future<Community?> getCommunityById(String id);
  Future<List<Community>> getCommunitiesUsingUsersCommunityIdList(
    List<String> refs,
  );
  Future<Community?> createCommunity(Community community);
  Future<Community?> updateCommunity(Community community);
  Future<List<Community>?> deleteCommunityById(String id);
  Future<bool> addSub(String commId, String userId);
  Future<bool> removeSub(String commId, String userId);
  Future<bool> addPost(String commId, String postId);
  Future<bool> removePost(String commId, String postId);
}
