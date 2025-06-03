import 'package:spotted/domain/models/models.dart';

abstract class AppconfigsDatasource {
  Future<AppConfigs> getAppConfigs();
  Future<AppConfigs?> updateAppConfigs(AppConfigs configs,
      {bool checkExistence = true});
}
