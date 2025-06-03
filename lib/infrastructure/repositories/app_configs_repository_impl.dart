

import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/domain/repositories/repositories.dart';
import 'package:spotted/infrastructure/datasources/datasources.dart';

class AppConfigsRepositoryImpl implements AppconfigsRepository {
  final AppconfigsDatasource _db;

  AppConfigsRepositoryImpl([AppconfigsDatasource? db])
      : _db = db ?? AppConfigsMockDatasourceImpl();

  @override
  Future<AppConfigs> getAppConfigs() async {
    return _db.getAppConfigs();
  }

  @override
  Future<AppConfigs?> updateAppConfigs(AppConfigs configs,
      {bool checkExistence = true}) {
    return _db.updateAppConfigs(configs);
  }
}
