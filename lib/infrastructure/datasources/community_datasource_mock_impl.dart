import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/community.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class CommunityDatasourceMockImpl implements CommunityDatasource {
  @override
  Future<Community?> createCommunity(Community community) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockCommunities.add(community);
      return community;
    });
  }

  @override
  Future<Community?> updateCommunity(Community community) async {
    final rng = Random();
    final randomTime = rng.nextInt(300);

    return await Future.delayed(Duration(milliseconds: randomTime), () {
      // find index of existing user
      final idx = mockCommunities.indexWhere((p) => p.id == community.id);
      if (idx != -1) {
        // replace the old user
        mockCommunities[idx] = community;
        return community;
      }
      // not found: nothing to update
      return null;
    });
  }

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
  Future<List<Community>> getCommunitiesUsingUsersCommunityIdList(
    List<String> refs,
  ) async {
    List<Future<Community?>> futures = [];

    for (String r in refs) {
      Future<Community?> future = getCommunityById(r);
      futures.add(future);
    }
    List<Community?> list = await Future.wait(futures);
    List<Community> nonNullCommunities = [];
    for (Community? c in list) {
      if (c != null) {
        nonNullCommunities.add(c);
      }
    }
    return nonNullCommunities;
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
  Future<Community?> getCommunityByTitle(String title) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      final comm = mockCommunities.where(
        (c) => c.title.toLowerCase().trim() == title.toLowerCase().trim(),
      );
      return comm.isEmpty ? null : comm.first;
    });
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
