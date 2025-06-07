import 'package:spotted/domain/models/models.dart';

abstract class InterestDatasource {
  Future<List<Interest>> createInterest(Interest newInterest);
  Future<List<Interest>> getAllInterests();
  Future<List<Interest>> getInterestsByName(String name);
  Future<Interest?> getInterestByName(String name);
  Future<Interest?> getInterestById(String id);
  Future<List<Interest>> getInterestsByIds(List<String> ids);
}
