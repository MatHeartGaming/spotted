import 'package:spotted/domain/models/models.dart';

abstract class AppconfigsRepository {
  Future<AppConfigs> getAppConfigs();
  Future<AppConfigs?> updateAppConfigs(AppConfigs configs,
      {bool checkExistence = true});
}
