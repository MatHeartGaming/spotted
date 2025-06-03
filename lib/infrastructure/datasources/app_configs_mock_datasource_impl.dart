import 'package:spotted/domain/models/app_configs.dart';
import 'package:spotted/domain/preview_data/mock_data.dart';

import '../../domain/datasources/appconfigs_datasource.dart';

class AppConfigsMockDatasourceImpl implements AppconfigsDatasource {
  @override
  Future<AppConfigs> getAppConfigs() async {
    return mockAppConfig;
  }

  @override
  Future<AppConfigs?> updateAppConfigs(
    AppConfigs configs, {
    bool checkExistence = true,
  }) async {
    mockAppConfig = mockAppConfig.copyWith(
      appIconBorderRadius: configs.appIconBorderRadius,
      appPrimaryColorHex: configs.appPrimaryColorHex,
      appStoreLink: configs.appStoreLink,
      buildNumberAndroid: configs.buildNumberAndroid,
      buildNumberIos: configs.buildNumberIos,
      deepLinkUrl: configs.deepLinkUrl,
      facebookLink: configs.facebookLink,
      instagramLink: configs.instagramLink,
      isInMaintenanceMode: configs.isInMaintenanceMode,
      playStoreLink: configs.playStoreLink,
      showDeveloperAppInfoDialog: configs.showDeveloperAppInfoDialog,
    );
    return mockAppConfig;
  }
}
