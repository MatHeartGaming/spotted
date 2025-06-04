import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/interest.dart';
import 'package:spotted/domain/repositories/interest_repository.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';

class InterestRepositoryImpl implements InterestRepository {
  final InterestDatasource _db;

  InterestRepositoryImpl([InterestDatasource? db])
    : _db = db ?? InterestDatasourceMockImpl();

  @override
  Future<List<Interest>> createInterest(Interest newInterest) {
    return _db.createInterest(newInterest);
  }

  @override
  Future<List<Interest>> getAllInterests() {
    return _db.getAllInterests();
  }

  @override
  Future<Interest?> getInterestById(String id) {
    return _db.getInterestById(id);
  }

  @override
  Future<Interest?> getInterestByName(String name) {
    return _db.getInterestByName(name);
  }

  @override
  Future<List<Interest>> getInterestsByName(String name) {
    return _db.getInterestsByName(name);
  }
}
