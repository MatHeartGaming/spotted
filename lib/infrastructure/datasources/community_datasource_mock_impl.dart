import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/community.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class CommunityDatasourceMockImpl implements CommunityDatasource {
  @override
  Future<List<Community>> getAllCommunities() async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockCommunities,
    );
  }

  @override
  Future<List<Community>> getCommunitiesByTitle(String title) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockCommunities
              .where((c) => c.title.toLowerCase().trim().contains(title))
              .toList(),
    );
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedBy(String createdById) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockCommunities
              .where(
                (c) => (c.createdById ?? '').toLowerCase().trim().contains(
                  createdById,
                ),
              )
              .toList(),
    );
  }

  @override
  Future<List<Community>> getCommunitiesByCreatedUsername(
    String createdByUsername,
  ) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () =>
          mockCommunities
              .where(
                (c) => (c.createdByUsername ?? '')
                    .toLowerCase()
                    .trim()
                    .contains(createdByUsername),
              )
              .toList(),
    );
  }

  @override
  Future<Community?> getCommunityById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(
      Duration(milliseconds: randomTime),
      () => mockCommunities.where((c) => c.id == id).toList().firstOrNull,
    );
  }
}
