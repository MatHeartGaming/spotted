import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/community.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';

class CommunityRepositoryImplementation implements CommunityRepository {
  final CommunityDatasource _db;

  CommunityRepositoryImplementation([CommunityDatasource? db])
    : _db = db ?? CommunityDatasourceMockImpl();

  @override
  Future<List<Community>> getAllCommunities() {
    return _db.getAllCommunities();
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedBy(String createdById) {
    return _db.getCommunitiesByCreatedBy(createdById);
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedUsername(
    String createdByUsername,
  ) {
    return _db.getCommunitiesByCreatedUsername(createdByUsername);
  }

  @override
  Future<List<Community>> getCommunitiesByTitle(String title) {
    return _db.getCommunitiesByTitle(title);
  }

  @override
  Future<Community?> getCommunityById(String id) {
    return _db.getCommunityById(id);
  }

  @override
  Future<Community?> createCommunity(Community community) {
    return _db.createCommunity(community);
  }

  @override
  Future<Community?> updateCommunity(Community community) {
    return _db.updateCommunity(community);
  }

  @override
  Future<List<Community>> getCommunitiesUsingUsersCommunityIdList(
    List<String> refs,
  ) {
    return _db.getCommunitiesUsingUsersCommunityIdList(refs);
  }
}
