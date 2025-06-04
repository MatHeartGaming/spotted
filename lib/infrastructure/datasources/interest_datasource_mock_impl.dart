import 'dart:math';

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

class InterestDatasourceMockImpl implements InterestDatasource {
  
  @override
  Future<List<Interest>> createInterest(Interest newInterest) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      mockInterests.add(newInterest);
      return mockInterests;
    });
  }

  @override
  Future<List<Interest>> getAllInterests() async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockInterests;
    });
  }

  @override
  Future<List<Interest>> getInterestsByName(String name) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockInterests
          .where(
            (f) =>
                f.name.toLowerCase().trim().contains(name.trim().toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Future<Interest?> getInterestByName(String name) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockInterests
          .where(
            (f) => f.name.toLowerCase().trim() == name.trim().toLowerCase(),
          )
          .firstOrNull;
    });
  }

  @override
  Future<Interest?> getInterestById(String id) async {
    var rng = Random();
    int randomTime = rng.nextInt(300);
    return await Future.delayed(Duration(milliseconds: randomTime), () {
      return mockInterests.where((f) => f.id?.trim() == id).firstOrNull;
    });
  }
}
