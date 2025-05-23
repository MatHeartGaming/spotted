import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/community.dart';


class CommunityDatasourceMockImpl implements CommunityDatasource {
  
  @override
  Future<List<Community>> getAllCommunities() async {
    return [];
  }

  @override
  Future<List<Community>> getCommunitiesByTitle(String title) async {
    return [];
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedBy(String createdById) async {
    return [];
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedUsername(String createdByUsername) async {
    return [];
  }

  @override
  Future<Community?> getCommunityById(String id) async {
    return null;
  }

  

}