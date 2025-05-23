import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/community.dart';


class CommunityDatasourceFirebaseImpl implements CommunityDatasource {
  @override
  Future<List<Community>> getAllCommunities() {
    // TODO: implement getAllCommunities
    throw UnimplementedError();
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedBy(String createdById) {
    // TODO: implement getCommunitiesByCreatedBy
    throw UnimplementedError();
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedUsername(String createdByUsername) {
    // TODO: implement getCommunitiesByCreatedUsername
    throw UnimplementedError();
  }

  @override
  Future<List<Community>> getCommunitiesByTitle(String title) {
    // TODO: implement getCommunitiesByTitle
    throw UnimplementedError();
  }

  @override
  Future<Community?> getCommunityById(String id) {
    // TODO: implement getCommunityById
    throw UnimplementedError();
  }
  

}